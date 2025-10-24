class Hardware {
  final String cpuInfo = '/proc/cpuinfo';
  final String meminfo = '/proc/meminfo';
  final String cpuinfoMaxFreq =
      '/sys/devices/system/cpu/n/cpufreq/cpuinfo_max_freq';
}
