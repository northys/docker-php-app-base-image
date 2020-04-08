<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class MbStringExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('mbstring'), 'extension_loaded reports true for "mbstring"');
    }
}
