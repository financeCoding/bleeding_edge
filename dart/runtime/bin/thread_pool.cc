// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "bin/thread_pool.h"

#include "bin/thread.h"

void TaskQueue::Insert(TaskQueueEntry* entry) {
  MonitorLocker monitor(&monitor_);
  monitor_.Enter();
  if (head_ == NULL) {
    head_ = entry;
    tail_ = entry;
    monitor.Notify();
  } else {
    tail_->set_next(entry);
    tail_ = entry;
  }
}


TaskQueueEntry* TaskQueue::Remove() {
  MonitorLocker monitor(&monitor_);
  TaskQueueEntry* result = head_;
  while (result == NULL) {
    if (terminate_) {
      return NULL;
    }
    monitor.Wait();
    if (terminate_) {
      return NULL;
    }
    result = head_;
  }
  head_ = result->next();
  ASSERT(head_ != NULL || tail_ == result);
  return result;
}


void TaskQueue::Shutdown() {
  MonitorLocker monitor(&monitor_);
  terminate_ = true;
  monitor.NotifyAll();
}


void ThreadPool::InsertTask(Task task) {
  TaskQueueEntry* entry = new TaskQueueEntry(task);
  queue_.Insert(entry);
}


Task ThreadPool::WaitForTask() {
  TaskQueueEntry* entry = queue_.Remove();
  if (entry == NULL) {
    return NULL;
  }
  Task task = entry->task();
  delete entry;
  return task;
}


void ThreadPool::Start() {
  MonitorLocker monitor(&monitor_);
  for (int i = 0; i < size_; i++) {
    int result = dart::Thread::Start(&ThreadPool::Main,
                                     reinterpret_cast<uword>(this));
    if (result != 0) {
      FATAL1("Failed to start thread pool thread %d", result);
    }
  }
}


void ThreadPool::Shutdown() {
  terminate_ = true;
  queue_.Shutdown();
  MonitorLocker monitor(&monitor_);
  while (size_ > 0) {
    monitor.Wait();
  }
}


void ThreadPool::ThreadTerminated() {
  MonitorLocker monitor(&monitor_);
  size_--;
  monitor.Notify();
}


void ThreadPool::Main(uword args) {
  if (Dart_IsVMFlagSet("trace_thread_pool")) {
    printf("Thread pool thread started\n");
  }
  ThreadPool* pool = reinterpret_cast<ThreadPool*>(args);
  while (!pool->terminate_) {
    if (Dart_IsVMFlagSet("trace_thread_pool")) {
      printf("Waiting for task\n");
    }
    Task task = pool->WaitForTask();
    if (pool->terminate_) break;
    (*(pool->task_handler_))(task);
  }
  pool->ThreadTerminated();
};
