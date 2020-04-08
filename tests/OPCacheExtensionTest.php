<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class OPCacheExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('opcache'), 'extension_loaded reports true for "opcache"');
    }
}
