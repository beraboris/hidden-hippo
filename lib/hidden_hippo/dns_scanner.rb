require 'open3'
require 'hidden_hippo/packets/dns'

module HiddenHippo
  class DnsScanner
    FIELDS = %w{wlan.sa wlan.da dns.ptr.domain_name}
    FILTER = 'dns'

    def initialize(file, *extractors)
      @file = file
      @extractors = extractors
    end

    def call
      # call Tshark
      Open3.popen3(%w(tshark tshark), '-2',
                   '-r', @file,
                   '-Tfields', *FIELDS.map {|f| ['-e', f]}.flatten,
                   '-R', FILTER) do |stdin, stdout, stderr, _|
        # we don't need those
        stdin.close
        stderr.close

        stdout.each do |line|
          puts line
          dns = parse line
          @extractors.each do |extractor|
            extractor.call(dns)
          end
        end
      end
    end

    def parse(line)
      Packets::Dns.new *line.chomp.split("\t")
    end
  end
end