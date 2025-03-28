<?php

declare(strict_types=1);

namespace Webauthn;

use InvalidArgumentException;
use Webauthn\AuthenticationExtensions\AuthenticationExtensions;

abstract class PublicKeyCredentialOptions
{
    public AuthenticationExtensions $extensions;

    /**
     * @param positive-int|null $timeout
     * @param null|AuthenticationExtensions|array<array-key, AuthenticationExtensions> $extensions
     * @protected
     */
    public function __construct(
        public string $challenge,
        public null|int $timeout = null,
        null|array|AuthenticationExtensions $extensions = null,
    ) {
        ($this->timeout === null || $this->timeout > 0) || throw new InvalidArgumentException('Invalid timeout');
        if ($extensions === null) {
            $this->extensions = AuthenticationExtensions::create();
        } elseif ($extensions instanceof AuthenticationExtensions) {
            $this->extensions = $extensions;
        } else {
            $this->extensions = AuthenticationExtensions::create($extensions);
        }
    }
}
