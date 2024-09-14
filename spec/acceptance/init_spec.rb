# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 's3daemon' do
  shell('dnf install -y podman-docker') # used by serverspec

  context 'with instances param' do
    include_examples 'the example', 'instances.pp'

    it_behaves_like 'an idempotent resource'

    context 'instance foo' do
      describe file('/etc/sysconfig/s3daemon-foo') do
        it { is_expected.to be_file }
        it { is_expected.to be_mode '600' }
        it { is_expected.to contain 'S3DAEMON_PORT=15556' }
        it { is_expected.to contain 'S3_ENDPOINT_URL=https://s3.foo.example.com' }
        it { is_expected.to contain 'AWS_ACCESS_KEY_ID=access_key_id' }
        it { is_expected.to contain 'AWS_SECRET_ACCESS_KEY=secret_access_key' }
      end

      describe docker_container('systemd-s3daemon-foo') do
        its(['Config.Image']) { is_expected.to eq 'ghcr.io/lsst-dm/s3daemon:main' }
        its(['Config.User']) { is_expected.to eq '65534:65534' }
        its(['HostConfig.NetworkMode']) { is_expected.to eq 'host' }

        its(['Mounts']) do
          is_expected.to contain_exactly(a_hash_including('Source' => '/home'))
        end
      end

      describe service('s3daemon-foo') do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end

      describe port(15_556) do
        it { is_expected.to be_listening.with('tcp') }
      end
    end

    context 'instance bar' do
      describe file('/etc/sysconfig/s3daemon-bar') do
        it { is_expected.to be_file }
        it { is_expected.to be_mode '600' }
        it { is_expected.to contain 'S3DAEMON_PORT=15557' }
        it { is_expected.to contain 'S3_ENDPOINT_URL=https://s3.bar.example.com' }
        it { is_expected.to contain 'AWS_ACCESS_KEY_ID=access_key_id' }
        it { is_expected.to contain 'AWS_SECRET_ACCESS_KEY=secret_access_key' }
      end

      describe docker_container('systemd-s3daemon-bar') do
        its(['Config.Image']) { is_expected.to eq 'ghcr.io/lsst-dm/s3daemon:sha-b5e72fa' }
        its(['Config.User']) { is_expected.to eq '65534:65534' }
        its(['HostConfig.NetworkMode']) { is_expected.to eq 'host' }

        its(['Mounts']) do
          is_expected.to contain_exactly(a_hash_including('Source' => '/home'), a_hash_including('Source' => '/opt'))
        end
      end

      describe service('s3daemon-bar') do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end

      describe port(15_557) do
        it { is_expected.to be_listening.with('tcp') }
      end
    end
  end
end
