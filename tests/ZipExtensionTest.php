<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class ZipExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('zip'), 'extension_loaded reports true for "zip"');
    }
}
