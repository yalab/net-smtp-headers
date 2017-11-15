require "test_helper"

class Net::SMTP::HeadersTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Net::SMTP::Headers::VERSION
  end

  def test_header_logging
    io = StringIO.new
    Net::SMTP.set_debug_output = io
    smtp = ::Net::SMTP.new(ENV["SMTP_HOST"], ENV["SMTP_PORT"])
    smtp.enable_starttls
    smtp.start("localhost", ENV["SMTP_USER"], ENV["SMTP_PASSWORD"], :plain) do |smtp|
      smtp.send_message(<<~EOS, 'from@example.com', 'rudeboyjet@gmail.com')
        From: Atsushi Yoshida <from@example.com>
        To: Atsushi Yoshida <rudeboyjet@gmail.com>
        Subject: test mail

        This is a test mail.
      EOS
    end
    io.rewind
    lines = io.read.split("\n")
    assert lines.find, /\AAUTH PLAIN/
    assert_equal '221 See you later', lines.last
  end
end
