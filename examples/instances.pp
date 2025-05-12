class { 's3daemon':
  env       => {
    'QUUX' => 'corge',
  },
  instances => {
    'foo' => {
      'aws_access_key_id'     => 'access_key_id',
      'aws_secret_access_key' => 'secret_access_key',
      'port'                  => 15556,
      'image'                 => 'ghcr.io/lsst-dm/s3daemon:main',
      'env'                   => {
        'S3_ENDPOINT_URL' => 'https://s3.foo.example.com',
        'FOO'             => 'bar',
        'BAZ'             => 'qux',
      },
    },
    'bar' => {
      'aws_access_key_id'     => 'access_key_id',
      'aws_secret_access_key' => 'secret_access_key',
      'port'                  => 15557,
      'image'                 => 'ghcr.io/lsst-dm/s3daemon:sha-b5e72fa',
      'volumes'               => ['/home:/home', '/opt:/opt'],
      'env'                   => {
        'S3_ENDPOINT_URL' => 'https://s3.bar.example.com',
        'FOO'             => 'bar',
        'BAZ'             => 'qux',
      },
    },
  },
}
