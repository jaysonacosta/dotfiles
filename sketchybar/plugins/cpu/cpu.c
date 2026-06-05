#include "../sketchybar.h"
#include <CoreFoundation/CoreFoundation.h>
#include <mach/mach_host.h>
#include <mach/host_info.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define CPU_ICON "􀫥"

// Cumulative CPU ticks from the previous sample.
static uint64_t prev_used = 0;
static uint64_t prev_total = 0;

// Read aggregate CPU ticks. used = user+system+nice, total = used+idle.
static int read_cpu(uint64_t* used, uint64_t* total) {
  host_cpu_load_info_data_t load;
  mach_msg_type_number_t count = HOST_CPU_LOAD_INFO_COUNT;
  if (host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO,
                      (host_info_t)&load, &count) != KERN_SUCCESS) {
    return 0;
  }
  *used = (uint64_t)load.cpu_ticks[CPU_STATE_USER]
        + (uint64_t)load.cpu_ticks[CPU_STATE_SYSTEM]
        + (uint64_t)load.cpu_ticks[CPU_STATE_NICE];
  *total = *used + (uint64_t)load.cpu_ticks[CPU_STATE_IDLE];
  return 1;
}

void callback(CFRunLoopTimerRef timer, void* info) {
  uint64_t used, total;
  if (!read_cpu(&used, &total)) return;

  uint64_t d_used = used - prev_used;
  uint64_t d_total = total - prev_total;
  prev_used = used;
  prev_total = total;

  // Utilization over the interval, rounded to a whole percent.
  int pct = (d_total > 0) ? (int)((d_used * 100 + d_total / 2) / d_total) : 0;

  // Icon carries glyph + percent so the graph stays the trailing element.
  char message[128];
  snprintf(message, sizeof(message), "--set cpu icon=\"%s %d%%\"", CPU_ICON, pct);
  sketchybar(message);
  snprintf(message, sizeof(message), "--push cpu %.4f", pct / 100.0);
  sketchybar(message);
}

int main(int argc, char** argv) {
  double freq = (argc > 1) ? atof(argv[1]) : 2.0;
  if (freq <= 0.0) freq = 2.0;

  // Prime counters, then paint once so the item isn't blank until the first tick.
  read_cpu(&prev_used, &prev_total);
  callback(NULL, NULL);

  CFRunLoopTimerRef timer = CFRunLoopTimerCreate(
      kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + freq, freq, 0, 0,
      callback, NULL);
  CFRunLoopAddTimer(CFRunLoopGetMain(), timer, kCFRunLoopDefaultMode);
  CFRunLoopRun();
  return 0;
}
