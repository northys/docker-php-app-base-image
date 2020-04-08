<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class BcMathExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('bcmath'), 'extension_loaded reports true for "bcmath"');
    }
}
