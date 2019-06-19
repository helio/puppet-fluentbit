# @summary Inputs / listen and forward messages
#
# Forward is the protocol used by Fluent Bit and Fluentd to route messages between peers.
# This plugin implements the input service to listen for Forward messages.
#
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
    String $configfile                  = '/etc/td-agent-bit/input_forward.conf',
    String $listen                      = '0.0.0.0',
    String $port                        = '24224',
    Optional[String] $buffer_max_size   = undef,
    Optional[String] $buffer_chunk_size = undef,
) {
  # create input_syslog.conf
  # TODO: concat for multiple entries
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/input/forward.conf.erb'),
    notify  => Class['fluentbit::service'],
  }
}
