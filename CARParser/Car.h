//
//  Car.h
//  CARParser
//
//  Created by Alexandre Colucci.
//  Copyright © 2018 Timac. All rights reserved.
//

#pragma once

// MARK: - carheader

struct carheader
{
    uint32_t tag;								// 'CTAR'
    uint32_t coreuiVersion;
    uint32_t storageVersion;
    uint32_t storageTimestamp;
    uint32_t renditionCount;
    char mainVersionString[128];
    char versionString[256];
    uuid_t uuid;
    uint32_t associatedChecksum;
    uint32_t schemaVersion;
    uint32_t colorSpaceID;
    uint32_t keySemantics;
} __attribute__((packed));


// MARK: - carextendedMetadata

struct carextendedMetadata {
    uint32_t tag;								// 'META'
    char thinningArguments[256];
    char deploymentPlatformVersion[256];
    char deploymentPlatform[256];
    char authoringTool[256];
} __attribute__((packed));



// MARK: - renditionkeytoken

// As seen in -[CUIRenditionKey nameOfAttributeName:]
enum RenditionAttributeType
{
	kRenditionAttributeType_ThemeLook 				= 0,
	kRenditionAttributeType_Element					= 1,
	kRenditionAttributeType_Part					= 2,
	kRenditionAttributeType_Size					= 3,
	kRenditionAttributeType_Direction				= 4,
	kRenditionAttributeType_placeholder				= 5,
	kRenditionAttributeType_Value					= 6,
	kRenditionAttributeType_ThemeAppearance			= 7,
	kRenditionAttributeType_Dimension1				= 8,
	kRenditionAttributeType_Dimension2				= 9,
	kRenditionAttributeType_State					= 10,
	kRenditionAttributeType_Layer					= 11,
	kRenditionAttributeType_Scale					= 12,
	kRenditionAttributeType_Unknown13				= 13,
	kRenditionAttributeType_PresentationState		= 14,
	kRenditionAttributeType_Idiom					= 15,
	kRenditionAttributeType_Subtype					= 16,
	kRenditionAttributeType_Identifier				= 17,
	kRenditionAttributeType_PreviousValue			= 18,
	kRenditionAttributeType_PreviousState			= 19,
	kRenditionAttributeType_HorizontalSizeClass		= 20,
	kRenditionAttributeType_VerticalSizeClass		= 21,
	kRenditionAttributeType_MemoryLevelClass		= 22,
	kRenditionAttributeType_GraphicsFeatureSetClass = 23,
	kRenditionAttributeType_DisplayGamut			= 24,
	kRenditionAttributeType_DeploymentTarget		= 25
};
typedef enum RenditionAttributeType RenditionAttributeType;


struct renditionAttribute {
	uint16_t name;
	uint16_t value;
} __attribute__((packed));


struct renditionkeytoken {
    struct {
		uint16_t x;
        uint16_t y;
    } cursorHotSpot;
	
	uint16_t numberOfAttributes;
    struct renditionAttribute attributes[];
} __attribute__((packed));


// MARK: - renditionkeyfmt


struct renditionkeyfmt {
    uint32_t tag;								// 'kfmt'
    uint32_t version;
    uint32_t maximumRenditionKeyTokenCount;
    uint32_t renditionKeyTokens[];
} __attribute__((packed));


// MARK: - csiheader


struct renditionFlags {
	uint32_t isHeaderFlaggedFPO:1;
	uint32_t isExcludedFromContrastFilter:1;
	uint32_t isVectorBased:1;
	uint32_t isOpaque:1;
	uint32_t bitmapEncoding:4;
	uint32_t optOutOfThinning:1;
	uint32_t isFlippable:1;
	uint32_t isTintable:1;
	uint32_t preservedVectorRepresentation:1;
	uint32_t reserved:20;
} __attribute__((packed));

struct csimetadata {
	uint32_t modtime;
	uint16_t layout;
	uint16_t zero;
	char name[128];
} __attribute__((packed));


struct csibitmaplist {
	uint32_t tvlLength;			// Length of all the TLV following the csiheader
    uint32_t unknown;
    uint32_t zero;
    uint32_t renditionLength;
} __attribute__((packed));


struct csiheader {
    uint32_t tag;								// 'CTSI'
    uint32_t version;
    struct renditionFlags renditionFlags;
    uint32_t width;
    uint32_t height;
    uint32_t scaleFactor;
    uint32_t pixelFormat;
	struct {
		uint32_t colorSpaceID:4;
		uint32_t reserved:28;
    } colorSpace;
    struct csimetadata csimetadata;
    struct csibitmaplist csibitmaplist;
} __attribute__((packed));


// MARK: - Layout


enum RenditionLayoutType
{
	kRenditionLayoutType_TextEffect				= 0x007,
	kRenditionLayoutType_Vector					= 0x009,
	
	kRenditionLayoutType_Data					= 0x3E8,
	kRenditionLayoutType_ExternalLink			= 0x3E9,
	kRenditionLayoutType_LayerStack				= 0x3EA,
	kRenditionLayoutType_InternalReference		= 0x3EB,
	kRenditionLayoutType_PackedImage			= 0x3EC,
	kRenditionLayoutType_NameList				= 0x3ED,
	kRenditionLayoutType_UnknownAddObject		= 0x3EE,
	kRenditionLayoutType_Texture				= 0x3EF,
	kRenditionLayoutType_TextureImage			= 0x3F0,
	kRenditionLayoutType_Color					= 0x3F1,
	kRenditionLayoutType_MultisizeImage			= 0x3F2,
	kRenditionLayoutType_LayerReference			= 0x3F4,
	kRenditionLayoutType_ContentRendition		= 0x3F5,
	kRenditionLayoutType_RecognitionObject		= 0x3F6,
};
typedef enum RenditionLayoutType RenditionLayoutType;

enum CoreThemeImageSubtype
{
	kCoreThemeOnePartFixedSize							= 10,
	kCoreThemeOnePartTile								= 11,
	kCoreThemeOnePartScale								= 12,
	kCoreThemeThreePartHTile							= 20,
	kCoreThemeThreePartHScale							= 21,
	kCoreThemeThreePartHUniform							= 22,
	kCoreThemeThreePartVTile							= 23,
	kCoreThemeThreePartVScale							= 24,
	kCoreThemeThreePartVUniform							= 25,
	kCoreThemeNinePartTile								= 30,
	kCoreThemeNinePartScale								= 31,
	kCoreThemeNinePartHorizontalUniformVerticalScale	= 32,
	kCoreThemeNinePartHorizontalScaleVerticalUniform 	= 33,
	kCoreThemeNinePartEdgesOnly 						= 34,
	kCoreThemeManyPartLayoutUnknown 					= 40,
	kCoreThemeAnimationFilmstrip 						= 50
};
typedef enum CoreThemeImageSubtype CoreThemeImageSubtype;


// MARK: - TLV


// As seen in -[CSIGenerator writeResourcesToData:]
enum RenditionTLVType
{
	kRenditionTLVType_Slices 				= 0x3E9,
	kRenditionTLVType_Metrics 				= 0x3EB,
	kRenditionTLVType_BlendModeAndOpacity	= 0x3EC,
	kRenditionTLVType_UTI	 				= 0x3ED,
	kRenditionTLVType_EXIFOrientation		= 0x3EE,
	kRenditionTLVType_ExternalTags			= 0x3F0,
	kRenditionTLVType_Frame					= 0x3F1,
};
typedef enum RenditionTLVType RenditionTLVType;


// MARK: - CUIRawDataRendition

struct CUIRawDataRendition {
    uint32_t tag;					// RAWD
    uint32_t version;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));


// MARK: - CUIRawPixelRendition

struct CUIRawPixelRendition {
    uint32_t tag;					// RAWD
    uint32_t version;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));


// MARK: - csicolor

struct csicolor {
	uint32_t tag;					// COLR
	uint32_t version;
	struct {
		uint32_t colorSpaceID:8;
		uint32_t unknown0:3;
		uint32_t reserved:21;
    } colorSpace;
	uint32_t numberOfComponents;
	double components[];
} __attribute__((packed));



// MARK: - CUIThemePixelRendition


// As seen in _CUIConvertCompressionTypeToString
enum RenditionCompressionType
{
	kRenditionCompressionType_uncompressed = 0,
	kRenditionCompressionType_rle,
	kRenditionCompressionType_zip,
	kRenditionCompressionType_lzvn,
	kRenditionCompressionType_lzfse,
	kRenditionCompressionType_jpeg_lzfse,
	kRenditionCompressionType_blurred,
	kRenditionCompressionType_astc,
	kRenditionCompressionType_palette_img,
	kRenditionCompressionType_deepmap_lzfse,
};
typedef enum RenditionCompressionType RenditionCompressionType;

struct CUIThemePixelRendition {
    uint32_t tag;					// 'CELM'
    uint32_t version;
    uint32_t compressionType;
    uint32_t rawDataLength;
	uint8_t rawData[];
} __attribute__((packed));

