<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class RedisExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('redis'), 'extension_loaded reports true for "redis"');
    }
}
