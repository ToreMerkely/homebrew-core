class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.40/phpstan.phar"
  sha256 "1dab44701707c35b7ee2ece145b414eca7f158fddc1d28e8d9954d45b55be117"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9720fbbd1bdcadb209a857b4c55a52008937fe6c99f67f9cfa5b204263ff78d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9720fbbd1bdcadb209a857b4c55a52008937fe6c99f67f9cfa5b204263ff78d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9720fbbd1bdcadb209a857b4c55a52008937fe6c99f67f9cfa5b204263ff78d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e88e311f13eedec4cf2cdafd4a85f3ba2ac9bd7bf5492ff4c86acc21882b7db"
    sha256 cellar: :any_skip_relocation, ventura:        "8e88e311f13eedec4cf2cdafd4a85f3ba2ac9bd7bf5492ff4c86acc21882b7db"
    sha256 cellar: :any_skip_relocation, monterey:       "8e88e311f13eedec4cf2cdafd4a85f3ba2ac9bd7bf5492ff4c86acc21882b7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9720fbbd1bdcadb209a857b4c55a52008937fe6c99f67f9cfa5b204263ff78d"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
