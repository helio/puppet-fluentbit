# @summary Input plugin to monitor one or several text files.
#
# The tail input plugin allows to monitor one or several text files.
# It has a similar behavior like `tail -f` shell command.
#
# @param configfile
#  Path to the input configfile. Naming should be input_*.conf to make sure
#  it's getting included by the main config.
#
# @param path
#   Pattern specifying a specific log files or multiple ones through the use of common wildcards.
#
# @param routing_tag
#   Set a tag (with regex-extract fields) that will be placed on lines read.
#
# @param storage_type
#   Specify the buffering mechanism to use.
#   Values: memory, filesystem
#
# @param buffer_chunk_size
#   Set the initial buffer size to read files data.
#
# @param buffer_max_size
#   Set the limit of the buffer size per monitored file.
#
# @param path_key
#   Appends the name of the monitored file as part of the record. The value assigned becomes the key in the map.
#
# @param exclude_path
#   Shell patterns to exclude files matching a certain criteria.
#
# @param refresh_interval
#   The interval of refreshing the list of watched files in seconds.
#
# @param rotate_wait
#   Specify the number of extra time in seconds to monitor a file once is
#   rotated in case some pending data is flushed.
#
# @param ignore_older
#   Ignores files that have been last modified before this time.
#
# @param skip_long_lines
#   When a monitored file reach it buffer capacity due to a very long line
#   (Buffer_Max_Size), the default behavior is to stop monitoring that file.
#   *Skip_Long_Lines* alters that behavior and instructs Fluent Bit to skip
#   long lines and continue processing other lines that fits into the buffer size.
#
# @param db
#   Specify the database file to keep track of monitored files and offsets.
#
# @param db_sync
#   Set a default synchronization (I/O) method.
#   Values: Extra, Full, Normal, Off.
#
# @param mem_buf_limit
#   Set a limit of memory that Tail plugin can use when appending data to the Engine.
#
# @param key
#   Name of the key to append any unstructured data to the output as.
#
# @param tag_regex
#   Set a regex to exctract fields from the file.
#
# @param multiline
#   Try to discover multiline messages and use the proper parsers to compose the outgoing messages.
#
# @param multiline_flush
#   Wait period time in seconds to process queued multiline messages.
#
# @param parsers
#   Name of parsers to use for disecting the message.
#   When *multiline* is enabled, the first array entry becomes the configuration
#   value for **Parser_Firstline**, with the remaining entry being assigned to
#   the **Parser_N** attributes.
#   When *multiline* is disabled, only the first item is used for the *Parser*
#   configuration value.
#
# @param docker_mode
#   Recombine split Docker log lines before passing them to any parser.
#
# @param docker_mode_flush
#   Wait period time in seconds to flush queued unfinished split lines.
#
define fluentbit::input::tail (
  Stdlib::Absolutepath $path,
  Stdlib::Absolutepath $configfile                          = "/etc/td-agent-bit/input_tail_${name}.conf",
  Optional[String[1]] $routing_tag                          = undef,
  Optional[Enum['memory', 'filesystem']] $storage_type      = undef,

  Optional[Fluentbit::Sizeunit] $buffer_chunk_size          = undef,
  Optional[Fluentbit::Sizeunit] $buffer_max_size            = undef,
  Optional[String[1]] $path_key                             = undef,
  Array[String] $exclude_path                               = [],
  Optional[Integer[1]] $refresh_interval                    = undef,
  Optional[Integer[1]] $rotate_wait                         = undef,
  Optional[Fluentbit::Timeunit] $ignore_older               = undef,
  Boolean $skip_long_lines                                  = false,
  Boolean $read_from_head                                   = false,
  Optional[Stdlib::Absolutepath] $db                        = undef,
  Optional[Enum['Extra', 'Full', 'Normal', 'Off']] $db_sync = undef,
  Optional[Fluentbit::Sizeunit] $mem_buf_limit              = undef,
  Optional[String[1]] $key                                  = undef,
  Optional[String[1]] $tag_regex                            = undef,

  Boolean $multiline                                        = false,
  Optional[Integer[1]] $multiline_flush                     = undef,
  Array[String[1]] $parsers                                 = [],

  Boolean $docker_mode                                      = false,
  Optional[Integer[1]] $docker_mode_flush                   = undef,
) {
  $skip_long_lines_string = bool2str($skip_long_lines, 'On', 'Off')
  $docker_mode_string = bool2str($docker_mode, 'On', 'Off')
  $read_from_head_string = bool2str($read_from_head, 'On', 'Off')

  file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/input/tail.conf.erb'),
    notify  => Class['fluentbit::service'],
  }
}
