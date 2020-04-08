<?php

namespace Tests;

use PHPUnit\Framework\TestCase;

class PdoExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('pdo'), 'extension_loaded reports true for "pdo"');
        self::assertTrue(extension_loaded('pdo_pgsql'), 'extension_loaded reports true for "pdo_pgsql"');
        self::assertTrue(extension_loaded('pdo_mysql'), 'extension_loaded reports true for "pdo_mysql"');
    }
}
