<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class JsonExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('json'), 'extension_loaded reports true for "json"');
    }
}
