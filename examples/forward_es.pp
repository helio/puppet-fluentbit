class { 'fluentbit':
  input_plugins  => [
    {
      name   => 'forward',
    },
  ],
  output_plugins => [
    {
      name       => 'es',
      properties => {
        index => 'example',
      },
    },
  ],
}
