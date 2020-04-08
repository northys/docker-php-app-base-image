<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class TokenizerExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('tokenizer'), 'extension_loaded reports true for "tokenizer"');
    }
}
