<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class IntlExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('intl'), 'extension_loaded reports true for "intl"');
    }
}
