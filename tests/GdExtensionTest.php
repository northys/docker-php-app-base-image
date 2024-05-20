<?php

namespace Tests;

use Nette\Utils\Image;
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\DataProvider;

class GdExtensionTest extends TestCase
{
    public function testExtensionAvailable()
    {
        self::assertTrue(extension_loaded('gd'), 'extension_loaded reports true for "gd"');
    }

    /**
     * @dataProvider dataProviderLoadAndSave
     */
    #[DataProvider('dataProviderLoadAndSave')]
    public function testLoadAndSave(int $imageType, string $extension)
    {
        $tmpLocation = sys_get_temp_dir() . DIRECTORY_SEPARATOR . getmypid() . '.' . $extension;

        $image = Image::fromFile(__DIR__ . '/logo.png');
        $image->resize(200, null);
        $image->save($tmpLocation);

        $resizedImage = Image::fromFile($tmpLocation);
        self::assertEquals(200, $resizedImage->getWidth());
    }

    public function dataProviderLoadAndSave()
    {
        return [
            [
                'imageType' => Image::JPEG,
                'extension' => 'jpg',
            ],
            [
                'imageType' => Image::PNG,
                'extension' => 'png',
            ],
            [
                'imageType' => Image::BMP,
                'extension' => 'bmp',
            ],
            [
                'imageType' => Image::GIF,
                'extension' => 'gif',
            ],
            [
                'imageType' => Image::WEBP,
                'extension' => 'webp',
            ],
        ];
    }
}
