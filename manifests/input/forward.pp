# @summary Inputs / listen and forward messages
#
# Forward is the protocol used by Fluent Bit and Fluentd to route messages between peers.
# This plugin implements the input service to listen for Forward messages.
#
# @param configfile
#  Path to the input configfile. Naming should be input_*.conf to make sure
#  it's getting included by the main config.
# @param listen
#  Listener network interface
# @param port
#  TCP port to listen for incoming connections.
# @param buffer_max_size
#  Specify the maximum buffer memory size used to receive a Forward message.
#  The value must be according to the Unit Size specification.
# @param buffer_chunk_size
#  By default the buffer to store the incoming Forward messages, do not allocate the maximum memory allowed,
#  instead it allocate memory when is required. The rounds of allocations are set by Buffer_Chunk_Size.
#  The value must be according to the Unit Size specification.
#
define fluentbit::input::forward (
    String $configfile                    = "/etc/td-agent-bit/input_forward_${name}.conf",
    Stdlib::IP::Address::Nosubnet $listen = '0.0.0.0',
    Stdlib::Port $port                    = 24224,
    Optional[String] $buffer_max_size     = undef,
    Optional[String] $buffer_chunk_size   = undef,
) {
  file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/input/forward.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
