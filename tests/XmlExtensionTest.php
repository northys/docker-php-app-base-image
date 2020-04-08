<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class XmlExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('xml'), 'extension_loaded reports true for "xml"');
    }
}
