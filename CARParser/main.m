//
//  main.m
//  CARParser
//
//  Created by Alexandre Colucci.
//  Copyright © 2018 Timac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bom.h"
#import "Car.h"

// Print an OSType
#define FourCC2Str(fourcc) (const char[]){*(((char*)&fourcc)+3), *(((char*)&fourcc)+2), *(((char*)&fourcc)+1), *(((char*)&fourcc)+0),0}


void PrintUsage()
{
	printf("NAME\n");
	printf("\t\tCARParser to parse bom files\n\n");
	
	printf("SYNOPSIS\n");
	printf("\t\tCARParser path\n\n");
	
	printf("DESCRIPTION\n");
	printf("\t\tCARParser is a command line tool to inspect the content of .car files.\n\n");
	
	printf("\n");
}


// MARK: - Utilities

NSString *GetUnixTimestampDescription(uint32_t inUnixTimestamp)
{
	NSString *formattedDate = nil;
	
	if(inUnixTimestamp > 0)
	{
		NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:inUnixTimestamp];
		if(theDate != nil)
		{
			NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
			NSISO8601DateFormatOptions options = NSISO8601DateFormatWithInternetDateTime | NSISO8601DateFormatWithDashSeparatorInDate | NSISO8601DateFormatWithColonSeparatorInTime | NSISO8601DateFormatWithTimeZone;
			formattedDate = [NSISO8601DateFormatter stringFromDate:theDate timeZone:timezone formatOptions:options];
		}
	}
	
	if(formattedDate == nil)
	{
		return [NSString stringWithFormat:@"%u", inUnixTimestamp];
	}
	else
	{
		return [NSString stringWithFormat:@"%u (%@)", inUnixTimestamp, formattedDate];
	}
}

NSString *GetOSTypeDescription(OSType inOSType)
{
	NSString *formattedString = nil;
	
	if(inOSType > 0)
	{
		formattedString = [NSString stringWithFormat:@"'%s' (0x%04X)", FourCC2Str(inOSType), inOSType];
	}
	else
	{
		formattedString = [NSString stringWithFormat:@"0x%04X", inOSType];
	}
	
	return formattedString;
}

NSString *GetScaleFactorDescription(uint32_t inScaleFactor)
{
	NSString *formattedScaleFactor = nil;
	
	if(inScaleFactor > 0 && ((inScaleFactor % 100) == 0))
	{
		formattedScaleFactor = [NSString stringWithFormat:@"%u (@%ux)", inScaleFactor, inScaleFactor / 100];
	}
	else
	{
		formattedScaleFactor = [NSString stringWithFormat:@"%u", inScaleFactor];
	}
	
	return formattedScaleFactor;
}

NSString *GetRenditionFlagsDescription(struct renditionFlags *inRenditionFlags)
{
	if(inRenditionFlags == NULL)
	{
		return @"";
	}
	
	NSMutableString *renditionFlagsString = [[NSMutableString alloc] initWithString:@""];
	
	BOOL shouldAddComma = NO;
	
	if(inRenditionFlags->isHeaderFlaggedFPO)
	{
		if(shouldAddComma)
		{
			[renditionFlagsString appendString:@","];
		}
		shouldAddComma = YES;
		
		[renditionFlagsString appendString:@"isHeaderFlaggedFPO"];
	}
	
	if(inRenditionFlags->isExcludedFromContrastFilter)
	{
		if(shouldAddComma)
		{
			[renditionFlagsString appendString:@","];
		}
		shouldAddComma = YES;
		
		[renditionFlagsString appendString:@"isExcludedFromContrastFilter"];
	}
	
	if(inRenditionFlags->isVectorBased)
	{
		if(shouldAddComma)
		{
			[renditionFlagsString appendString:@","];
		}
		shouldAddComma = YES;
		
		[renditionFlagsString appendString:@"isVectorBased"];
	}
	
	if(inRenditionFlags->isOpaque)
	{
		if(shouldAddComma)
		{
			[renditionFlagsString appendString:@","];
		}
		shouldAddComma = YES;
		
		[renditionFlagsString appendString:@"isOpaque"];
	}
	
	if(shouldAddComma)
	{
		[renditionFlagsString appendString:@","];
	}
	shouldAddComma = YES;
	
	[renditionFlagsString appendString:[NSString stringWithFormat:@"bitmapEncoding %X", inRenditionFlags->bitmapEncoding]];
	
	if(inRenditionFlags->optOutOfThinning)
	{
		if(shouldAddComma)
		{
			[renditionFlagsString appendString:@","];
		}
		shouldAddComma = YES;
		
		[renditionFlagsString appendString:@"optOutOfThinning"];
	}
	
	if(inRenditionFlags->isFlippable)
	{
		if(shouldAddComma)
		{
			[renditionFlagsString appendString:@","];
		}
		shouldAddComma = YES;
		
		[renditionFlagsString appendString:@"isFlippable"];
	}
	
	if(inRenditionFlags->isTintable)
	{
		if(shouldAddComma)
		{
			[renditionFlagsString appendString:@","];
		}
		shouldAddComma = YES;
		
		[renditionFlagsString appendString:@"isTintable"];
	}
	
	if(inRenditionFlags->preservedVectorRepresentation)
	{
		if(shouldAddComma)
		{
			[renditionFlagsString appendString:@","];
		}
		shouldAddComma = YES;
		
		[renditionFlagsString appendString:@"preservedVectorRepresentation"];
	}
	
	// Prevent a never read warning
	(void)shouldAddComma;
	
	return renditionFlagsString;
}

NSString *GetNameOfAttributeType(RenditionAttributeType inAttributeType)
{
	switch (inAttributeType)
	{
  		case kRenditionAttributeType_ThemeLook:
    		return @"Theme Look";
		break;
		
		case kRenditionAttributeType_Element:
    		return @"Element";
		break;
		
		case kRenditionAttributeType_Part:
    		return @"Part";
		break;
		
		case kRenditionAttributeType_Size:
    		return @"Size";
		break;
		
		case kRenditionAttributeType_Direction:
    		return @"Direction";
		break;
		
		case kRenditionAttributeType_placeholder:
    		return @"placeholder";
		break;
		
		case kRenditionAttributeType_Value:
    		return @"Value";
		break;
		
		case kRenditionAttributeType_ThemeAppearance:
    		return @"Theme Appearance";
		break;
		
		case kRenditionAttributeType_Dimension1:
    		return @"Dimension 1";
		break;
		
		case kRenditionAttributeType_Dimension2:
    		return @"Dimension 2";
		break;
		
		case kRenditionAttributeType_State:
    		return @"State";
		break;
		
		case kRenditionAttributeType_Layer:
    		return @"Layer";
		break;
		
		case kRenditionAttributeType_Scale:
    		return @"Scale";
		break;
		
		case kRenditionAttributeType_PresentationState:
    		return @"Presentation State";
		break;
		
		case kRenditionAttributeType_Idiom:
    		return @"Idiom";
		break;
		
		case kRenditionAttributeType_Subtype:
    		return @"Subtype";
		break;
		
		case kRenditionAttributeType_Identifier:
    		return @"Identifier";
		break;
		
		case kRenditionAttributeType_PreviousValue:
    		return @"Previous Value";
		break;
		
		case kRenditionAttributeType_PreviousState:
    		return @"Previous State";
		break;
		
		case kRenditionAttributeType_HorizontalSizeClass:
    		return @"Horizontal Size Class";
		break;
		
		case kRenditionAttributeType_VerticalSizeClass:
    		return @"Vertical Size Class";
		break;
		
		case kRenditionAttributeType_MemoryLevelClass:
    		return @"Memory Level Class";
		break;
		
		case kRenditionAttributeType_GraphicsFeatureSetClass:
    		return @"Graphics Feature Set Class";
		break;
		
		case kRenditionAttributeType_DisplayGamut:
    		return @"Display Gamut";
		break;
		
		case kRenditionAttributeType_DeploymentTarget:
    		return @"Deployment Target";
		break;

  		default:
  			return [NSString stringWithFormat:@"Unknown %d", inAttributeType];
    	break;
	}
}

// From -[CUINamedColor _colorSpaceWithID:]
NSString *GetColorSpaceNameWithID(int64_t inColorSpaceID)
{
	switch (inColorSpaceID)
	{
  		case 0:
  		default:
  		{
			return @"SRGB";
  		}
		break;
		
		case 1:
  		{
			return @"GrayGamma2_2";
  		}
		break;
		
		case 2:
  		{
			return @"DisplayP3";
  		}
		break;
		
		case 3:
  		{
			return @"ExtendedRangeSRGB";
  		}
		break;
		
		case 4:
  		{
			return @"ExtendedLinearSRGB";
  		}
		break;
		
		case 5:
  		{
			return @"ExtendedGray";
  		}
		break;
	}
}

NSString *GetTLVTNameWithType(RenditionTLVType inTLVType)
{
	switch (inTLVType)
	{
  		case kRenditionTLVType_Slices:
  		{
			return @"Slices";
  		}
		break;
		
		case kRenditionTLVType_Metrics:
  		{
			return @"Metrics";
  		}
		break;
		
		case kRenditionTLVType_BlendModeAndOpacity:
  		{
			return @"BlendModeAndOpacity";
  		}
		break;
		
		case kRenditionTLVType_UTI:
  		{
			return @"UTI";
  		}
		break;
		
		case kRenditionTLVType_EXIFOrientation:
  		{
			return @"EXIFOrientation";
  		}
		break;
		
		case kRenditionTLVType_ExternalTags:
  		{
			return @"ExternalTags";
  		}
		break;
		
		case kRenditionTLVType_Frame:
  		{
			return @"Frame";
  		}
		break;
		
		default:
		{
			return [NSString stringWithFormat:@"Unknown 0x%04X", inTLVType];
		}
		break;
	}
}

NSString *GetNameWithCoreThemeImageSubType(CoreThemeImageSubtype inType)
{
	switch (inType)
	{
		case kCoreThemeOnePartFixedSize:
  		{
			return @"One Part Fixed Size";
  		}
		break;
		
  		case kCoreThemeOnePartTile:
  		{
			return @"One Part Tiled";
  		}
		break;
		
		case kCoreThemeOnePartScale:
		{
			return @"One Part Scaled";
		}
		break;
		
		case kCoreThemeThreePartHTile:
  		{
			return @"Three Part Horizontal Tiled";
  		}
		break;
		
		case kCoreThemeThreePartHScale:
  		{
			return @"Three Part Horizontal Scaled";
  		}
		break;
		
		case kCoreThemeThreePartHUniform:
  		{
			return @"Three Part Horizontal Uniform";
  		}
		break;
		
		case kCoreThemeThreePartVTile:
  		{
			return @"Three Part Vertical Tiled";
  		}
		break;
		
		case kCoreThemeThreePartVScale:
  		{
			return @"Three Part Vertical Scaled";
  		}
		break;
		
		case kCoreThemeThreePartVUniform:
  		{
			return @"Three Part Vertical Uniform";
  		}
		break;
		
		case kCoreThemeNinePartTile:
  		{
			return @"Nine Part Tiled";
  		}
		break;
		
		case kCoreThemeNinePartScale:
  		{
			return @"Nine Part Scaled";
  		}
		break;
		
		case kCoreThemeNinePartHorizontalUniformVerticalScale:
  		{
			return @"Nine Part Horizontal Uniform Vertical Scaled";
  		}
		break;
		
		case kCoreThemeNinePartHorizontalScaleVerticalUniform:
  		{
			return @"Nine Part Horizontal Scaled Vertical Uniform";
  		}
		break;
		
		case kCoreThemeNinePartEdgesOnly:
  		{
			return @"Nine Part Edges Only";
  		}
		break;
		
		case kCoreThemeManyPartLayoutUnknown:
  		{
			return @"Many Part Layout Unknown";
  		}
		break;
		
		case kCoreThemeAnimationFilmstrip:
  		{
			return @"Animation Filmstrip";
  		}
		break;
		
		default:
		{
			return [NSString stringWithFormat:@"Unknown 0x%04X", inType];
		}
		break;
	}
}

NSString *GetRenditionLayoutNameWithType(RenditionLayoutType inType)
{
	if(inType >= kCoreThemeOnePartFixedSize && inType < kRenditionLayoutType_Data)
	{
		return [NSString stringWithFormat:@"Image (%@)", GetNameWithCoreThemeImageSubType((CoreThemeImageSubtype)inType)];
	}
	
	switch (inType)
	{
		case kRenditionLayoutType_TextEffect:
  		{
			return @"TextEffect";
  		}
		break;
		
		case kRenditionLayoutType_Data:
		{
			return @"Data";
		}
		break;
		
		case kRenditionLayoutType_ExternalLink:
  		{
			return @"ExternalLink";
  		}
		break;
		
		case kRenditionLayoutType_LayerStack:
  		{
			return @"LayerStack";
  		}
		break;
		
		case kRenditionLayoutType_InternalReference:
  		{
			return @"InternalReference";
  		}
		break;
		
		case kRenditionLayoutType_PackedImage:
  		{
			return @"PackedImage";
  		}
		break;
		
		case kRenditionLayoutType_NameList:
  		{
			return @"NameList";
  		}
		break;
		
		case kRenditionLayoutType_UnknownAddObject:
  		{
			return @"UnknownAddObject";
  		}
		break;
		
		case kRenditionLayoutType_Texture:
  		{
			return @"Texture";
  		}
		break;
		
		case kRenditionLayoutType_TextureImage:
  		{
			return @"TextureImage";
  		}
		break;
		
		case kRenditionLayoutType_Color:
  		{
			return @"Color";
  		}
		break;
		
		case kRenditionLayoutType_MultisizeImage:
  		{
			return @"MultisizeImage";
  		}
		break;
		
		case kRenditionLayoutType_LayerReference:
  		{
			return @"LayerReference";
  		}
		break;
		
		case kRenditionLayoutType_ContentRendition:
  		{
			return @"ContentRendition";
  		}
		break;
		
		case kRenditionLayoutType_RecognitionObject:
  		{
			return @"Recognition";
  		}
		break;
		
		default:
		{
			return [NSString stringWithFormat:@"Unknown 0x%04X", inType];
		}
		break;
	}
}

NSString *GetRenditionCompressionDescription(RenditionCompressionType inCompressionType)
{
	switch (inCompressionType)
	{
  		case kRenditionCompressionType_uncompressed:
    		return @"uncompressed";
		break;
		
		case kRenditionCompressionType_rle:
    		return @"rle";
		break;
		
		case kRenditionCompressionType_zip:
    		return @"zip";
		break;
		
		case kRenditionCompressionType_lzvn:
    		return @"lzvn";
		break;
		
		case kRenditionCompressionType_lzfse:
    		return @"lzfse";
		break;
		
		case kRenditionCompressionType_jpeg_lzfse:
    		return @"jpeg-lzfse";
		break;
		
		case kRenditionCompressionType_blurred:
    		return @"blurred";
		break;
		
		case kRenditionCompressionType_astc:
    		return @"astc";
		break;
		
		case kRenditionCompressionType_palette_img:
    		return @"palette-img";
		break;
		
		case kRenditionCompressionType_deepmap_lzfse:
    		return @"deepmap-lzfse";
		break;

  		default:
  			return @"Unknown";
    	break;
	}
}


// MARK: - BOM utilities

NSData *GetDataFromBomBlock(BOMStorage inBOMStorage, const char *inBlockName)
{
	NSData *outData = nil;
	
	BOMBlockID blockID = BOMStorageGetNamedBlock(inBOMStorage, inBlockName);
	size_t blockSize = BOMStorageSizeOfBlock(inBOMStorage, blockID);
	if(blockSize > 0)
	{
		void *mallocedBlock = malloc(blockSize);
		int res = BOMStorageCopyFromBlock(inBOMStorage, blockID, mallocedBlock);
		if(res == noErr)
		{
			outData = [[NSData alloc] initWithBytes:mallocedBlock length:blockSize];
		}
		
		free(mallocedBlock);
	}
	
	return outData;
}

typedef void (^ParseBOMTreeCallback)(NSData *inKey, NSData *inValue);
void ParseBOMTree(BOMStorage inBOMStorage, const char *inTreeName, ParseBOMTreeCallback keyValueCallback)
{
	NSData *keyData = nil;
	NSData *keyValue = nil;
	
	// Open the BOM tree
	BOMTree bomTree = BOMTreeOpenWithName(inBOMStorage, inTreeName, false);
	if(bomTree == NULL)
		return;

	// Create a BOMTreeIterator and loop until the end
	BOMTreeIterator	bomIterator = BOMTreeIteratorNew(bomTree, NULL, NULL, NULL);
	while(!BOMTreeIteratorIsAtEnd(bomIterator))
	{
		// Get the key
		void * key = BOMTreeIteratorKey(bomIterator);
		size_t keySize = BOMTreeIteratorKeySize(bomIterator);
		keyData = [NSData dataWithBytes:key length:keySize];
		
		// Get the value associated to the key
		size_t valueSize = BOMTreeIteratorValueSize(bomIterator);
		if(valueSize > 0)
		{
			void * value = BOMTreeIteratorValue(bomIterator);
			if(value != NULL)
			{
				keyValue = [NSData dataWithBytes:value length:valueSize];
			}
		}
		
		if(keyData != nil)
		{
			keyValueCallback(keyData, keyValue);
		}
		
		// Next item in the tree
		BOMTreeIteratorNext(bomIterator);
	}
}


// MARK: - Parse the .car file

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		if(argc != 2)
		{
			PrintUsage();
			return -1;
		}
		
		NSString *path = [NSString stringWithUTF8String:argv[1]];
		
		BOMStorage bomStorage = BOMStorageOpen([path fileSystemRepresentation], false);
		
		// Dump CARHEADER
		{
			NSData *blockData = GetDataFromBomBlock(bomStorage, "CARHEADER");
			if(blockData != nil)
			{
				struct carheader *carHeader = (struct carheader *)[blockData bytes];
				if(carHeader->tag == 'RATC')
				{
					// The header should be swapped
					NSLog(@"The CARHEADER header should be swapped");
				}
				
				fprintf(stderr, "\nCARHEADER:\n"
					"\t coreuiVersion: %u\n"
					"\t storageVersion: %u\n"
					"\t storageTimestamp: %s\n"
					"\t renditionCount: %u\n"
					"\t mainVersionString: %s"
					"\t versionString: %s\n"
					"\t uuid: %s\n"
					"\t associatedChecksum: 0x%04X\n"
					"\t schemaVersion: %u\n"
					"\t colorSpaceID: %u\n"
					"\t keySemantics: %u\n",
					carHeader->coreuiVersion,
					carHeader->storageVersion,
					[GetUnixTimestampDescription(carHeader->storageTimestamp) UTF8String],
					carHeader->renditionCount,
					carHeader->mainVersionString,
					carHeader->versionString,
					[[[[NSUUID alloc] initWithUUIDBytes:carHeader->uuid] UUIDString] UTF8String],
					carHeader->associatedChecksum,
					carHeader->schemaVersion,
					carHeader->colorSpaceID,
					carHeader->keySemantics);
			}
			else
			{
				NSLog(@"Invalid CARHEADER");
			}
		}
		
		// Dump EXTENDED_METADATA
		{
			NSData *blockData = GetDataFromBomBlock(bomStorage, "EXTENDED_METADATA");
			if(blockData != nil)
			{
				struct carextendedMetadata *carExtendedMetadata = (struct carextendedMetadata *)[blockData bytes];
				
				fprintf(stderr, "\nEXTENDED_METADATA:\n"
					"\t thinningArguments: %s\n"
					"\t deploymentPlatformVersion: %s\n"
					"\t deploymentPlatform: %s\n"
					"\t authoringTool: %s\n",
					carExtendedMetadata->thinningArguments,
					carExtendedMetadata->deploymentPlatformVersion,
					carExtendedMetadata->deploymentPlatform,
					carExtendedMetadata->authoringTool);
			}
			else
			{
				NSLog(@"Invalid EXTENDED_METADATA");
			}
		}
		
		// Dump CARGLOBALS
		{
			NSData *blockData = GetDataFromBomBlock(bomStorage, "CARGLOBALS");
			if(blockData != nil)
			{
				NSLog(@"CARGLOBALS: %@", blockData);
			}
		}
		
		
		NSMutableArray<NSString *> *keyFormatStrings = [[NSMutableArray alloc] init];
		
		// Dump KEYFORMAT
		{
			NSData *blockData = GetDataFromBomBlock(bomStorage, "KEYFORMAT");
			if(blockData != nil)
			{
				struct renditionkeyfmt *keyFormat = (struct renditionkeyfmt *)[blockData bytes];
				
				fprintf(stderr, "\nKEYFORMAT:\n"
					"\t maximumRenditionKeyTokenCount: %u\n",
					keyFormat->maximumRenditionKeyTokenCount);
				
				for(uint32_t renditionKeyTokenIndex = 0 ; renditionKeyTokenIndex < keyFormat->maximumRenditionKeyTokenCount ; renditionKeyTokenIndex++)
				{
					NSString *attributeName = GetNameOfAttributeType(keyFormat->renditionKeyTokens[renditionKeyTokenIndex]);
					fprintf(stderr, "\t renditionKeyTokens: %s\n", [attributeName UTF8String]);
					[keyFormatStrings addObject:attributeName];
				}
			}
			else
			{
				NSLog(@"Invalid KEYFORMAT");
			}
		}
		
		// Dump KEYFORMATWORKAROUND
		{
			NSData *blockData = GetDataFromBomBlock(bomStorage, "KEYFORMATWORKAROUND");
			if(blockData != nil)
			{
				struct renditionkeyfmt *keyFormatWorkaround = (struct renditionkeyfmt *)[blockData bytes];
				
				fprintf(stderr, "\nKEYFORMATWORKAROUND:\n"
					"\t maximumRenditionKeyTokenCount: %u\n",
					keyFormatWorkaround->maximumRenditionKeyTokenCount);
				
				for(uint32_t renditionKeyTokenIndex = 0 ; renditionKeyTokenIndex < keyFormatWorkaround->maximumRenditionKeyTokenCount ; renditionKeyTokenIndex++)
				{
					fprintf(stderr, "\t renditionKeyTokens: %s\n", [GetNameOfAttributeType(keyFormatWorkaround->renditionKeyTokens[renditionKeyTokenIndex]) UTF8String]);
				}
			}
		}
		
		// Dump EXTERNAL_KEYS
		{
			NSData *blockData = GetDataFromBomBlock(bomStorage, "EXTERNAL_KEYS");
			if(blockData != nil)
			{
				NSLog(@"EXTERNAL_KEYS: %@", blockData);
			}
		}
		
		fprintf(stderr, "\nTree APPEARANCEKEYS\n");
		ParseBOMTree(bomStorage, "APPEARANCEKEYS", ^(NSData *inKey, NSData *inValue)
		{
			NSString *appearanceName = [[NSString alloc] initWithBytes:[inKey bytes] length:[inKey length] encoding:NSUTF8StringEncoding];
			uint16_t appearanceIdentifier = 0;
			if(inValue != nil)
			{
				appearanceIdentifier = *(uint16_t *)([inValue bytes]);
			}
			
			fprintf(stderr, "\t '%s': %u\n", [appearanceName UTF8String], appearanceIdentifier);
		});
		
		fprintf(stderr, "\nTree FACETKEYS\n");
		ParseBOMTree(bomStorage, "FACETKEYS", ^(NSData *inKey, NSData *inValue)
		{
			NSString *facetName = [[NSString alloc] initWithBytes:[inKey bytes] length:[inKey length] encoding:NSUTF8StringEncoding];
			fprintf(stderr, "\t '%s':", [facetName UTF8String]);
			
			const void *bytes = [inValue bytes];
			if(bytes != NULL)
			{
				struct renditionkeytoken *renditionkeytoken = (struct renditionkeytoken *)bytes;
				uint16_t numberOfAttributes = renditionkeytoken->numberOfAttributes;
				for(uint16_t keyIndex = 0 ; keyIndex < numberOfAttributes ; keyIndex++)
				{
					struct renditionAttribute renditionAttribute = renditionkeytoken->attributes[keyIndex];
					fprintf(stderr, "\n\t\t %s: %04X", [GetNameOfAttributeType(renditionAttribute.name) UTF8String], renditionAttribute.value);
				}
			}
			
			fprintf(stderr, "\n");
		});
		
		fprintf(stderr, "\nTree RENDITIONS\n");
		ParseBOMTree(bomStorage, "RENDITIONS", ^(NSData *inKey, NSData *inValue)
		{
			fprintf(stderr, "\n\t Key '%s'\n", [[inKey description] UTF8String]);
			
			// Parse the key
			const void *keyBytes = [inKey bytes];
			for(uint16_t keyIndex = 0 ; keyIndex < ([inKey length] / 2) ; keyIndex++)
			{
				uint16_t key = *(uint16_t *)(keyBytes + 2 * keyIndex);
				fprintf(stderr, "\t\t %s: %04X\n", [keyFormatStrings[keyIndex] UTF8String], key);
			}
			
			// Parse the value
			if(inValue != nil)
			{
				const void *valueBytes = [inValue bytes];
				
				struct csiheader *csiHeader = (struct csiheader *)valueBytes;
				
				fprintf(stderr, "\n\t\t csiHeader:\n"
					"\t\t\t version: %u\n"
					"\t\t\t renditionFlags: %s\n"
					"\t\t\t width: %u\n"
					"\t\t\t height: %u\n"
					"\t\t\t scaleFactor: %s\n"
					"\t\t\t pixelFormat: %s\n"
					"\t\t\t colorSpaceID: %u\n"
					"\t\t\t modtime: %s\n"
					"\t\t\t layout: %s\n"
					"\t\t\t name: %s\n"
					"\t\t\t tvlLength: %u\n"
					"\t\t\t renditionLength: %u\n"
					,
					csiHeader->version,
					[GetRenditionFlagsDescription(&(csiHeader->renditionFlags)) UTF8String],
					csiHeader->width,
					csiHeader->height,
					[GetScaleFactorDescription(csiHeader->scaleFactor) UTF8String],
					[GetOSTypeDescription(csiHeader->pixelFormat) UTF8String],
					csiHeader->colorSpace.colorSpaceID,
					[GetUnixTimestampDescription(csiHeader->csimetadata.modtime) UTF8String],
					[GetRenditionLayoutNameWithType(csiHeader->csimetadata.layout) UTF8String],
					csiHeader->csimetadata.name,
					csiHeader->csibitmaplist.tvlLength,
					csiHeader->csibitmaplist.renditionLength);
				
				// Print the TLV
				uint32_t tvlLength = csiHeader->csibitmaplist.tvlLength;
				if(tvlLength > 0)
				{
					fprintf(stderr, "\t\t\t tlv:\n");
					
					const void *tlvBytes = valueBytes + sizeof(*csiHeader);
					const void *tlvPos = tlvBytes;
					
					while(tlvBytes + tvlLength > tlvPos)
					{
						uint32_t tlvTag = *(uint32_t *)tlvPos;
						uint32_t tlvLength = *(uint32_t *)(tlvPos + 4);
						
						fprintf(stderr, "\t\t\t\t %s: " , [GetTLVTNameWithType(tlvTag) UTF8String]);
						for(uint32_t valuePos = 0 ; valuePos < tlvLength ; valuePos++)
						{
							fprintf(stderr, "%02X" , *(uint8_t*)(tlvPos + 8 + valuePos));
						}
						
						fprintf(stderr, "\n");
						
						tlvPos += 8 + tlvLength;
					}
				}
				
				const void *renditionBytes = valueBytes + sizeof(*csiHeader) + csiHeader->csibitmaplist.tvlLength;
				
				if(csiHeader->pixelFormat == 'DATA')
				{
					struct CUIRawDataRendition *rawDataRendition = (struct CUIRawDataRendition *)renditionBytes;
					if(rawDataRendition->tag == 'RAWD')
					{
						uint32_t rawDataLength = rawDataRendition->rawDataLength;
						uint8_t *rawData = rawDataRendition->rawData;
						if(rawDataLength > 4)
						{
							fprintf(stderr, "\t\t\t Found RawDataRendition with size %u: 0x%02X%02X%02X%02X...\n", rawDataLength, *(uint8_t*)rawData, *(uint8_t*)(rawData + 1), *(uint8_t*)(rawData + 2), *(uint8_t*)(rawData + 3));
						}
						else
						{
							fprintf(stderr, "\t\t\t Found RawDataRendition with size %u\n", rawDataLength);
						}
					}
				}
				else if(csiHeader->pixelFormat == 'JPEG' || csiHeader->pixelFormat == 'HEIF')
				{
					struct CUIRawPixelRendition *rawPixelRendition = (struct CUIRawPixelRendition *)renditionBytes;
					if(rawPixelRendition->tag == 'RAWD')
					{
						uint32_t rawDataLength = rawPixelRendition->rawDataLength;
						uint8_t *rawDataBytes = rawPixelRendition->rawData;
						
						NSData *rawData = [[NSData alloc] initWithBytes:rawDataBytes length:rawDataLength];
						CGImageSourceRef sourceRef = CGImageSourceCreateWithData((CFDataRef)rawData, NULL);
						CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
						fprintf(stderr, "\t\t\t Found RawPixelRendition of size (%ld x %ld) with rawDataLength %u\n", CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), rawDataLength);
						CFRelease(imageRef);
						CFRelease(sourceRef);
					}
				}
				else if(csiHeader->pixelFormat == 0 && csiHeader->csimetadata.layout == kRenditionLayoutType_Color)
				{
					struct csicolor *colorRendition = (struct csicolor *)renditionBytes;
					
					if(colorRendition->numberOfComponents == 4)
					{
						// Use the hardcoded DeviceRGB color space instead of the real colorSpace from the colorSpaceID
						CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
						CGColorRef __unused theColor = CGColorCreate(colorSpaceRef, colorRendition->components);
						CFRelease(theColor);
						CFRelease(colorSpaceRef);
						
						NSString *colorString = [NSString stringWithFormat:@"%f,%f,%f,%f", colorRendition->components[0], colorRendition->components[1], colorRendition->components[2], colorRendition->components[3]];
						fprintf(stderr, "\n\t\t Found Color %s with colorspace ID %d\n", [colorString UTF8String], colorRendition->colorSpace.colorSpaceID & 0xFF);
					}
					else
					{
						fprintf(stderr, "\n\t\t Found Color with colorspace ID %d but with %u components\n", colorRendition->colorSpace.colorSpaceID & 0xFF, colorRendition->numberOfComponents);
					}
				}
				else if(csiHeader->pixelFormat == 'ARGB' || csiHeader->pixelFormat == 'GA8 ' ||
					csiHeader->pixelFormat == 'RGB5' || csiHeader->pixelFormat == 'RGBW' ||
					csiHeader->pixelFormat == 'GA16')
				{
					struct CUIThemePixelRendition *themePixelRendition = (struct CUIThemePixelRendition *)renditionBytes;
					
					uint32_t compressionType = themePixelRendition->compressionType;
					uint32_t rawDataLength = themePixelRendition->rawDataLength;
					uint8_t * __unused rawDataBytes = themePixelRendition->rawData;
					
					fprintf(stderr, "\n\t\t Found ThemePixelRendition with size %u and compression %s\n", rawDataLength, [GetRenditionCompressionDescription(compressionType) UTF8String]);
				}
				else
				{
					fprintf(stderr, "\n\t\t Found unknown rendition with pixel format %s\n", FourCC2Str(csiHeader->pixelFormat));
				}
			}
		});
		
		// Dump the other trees
		NSArray <NSString *> *treeNames = @[ @"COLORS", @"FONTS", @"FONTSIZES", @"GLYPHS", @"BEZELS", @"BITMAPKEYS", @"ELEMENT_INFO", @"PART_INFO"];
		for(NSString *treeName in treeNames)
		{
			fprintf(stderr, "\nTree '%s'\n", [treeName UTF8String]);
			
			BOMTree bomTree = BOMTreeOpenWithName(bomStorage, [treeName UTF8String], false);
			if(bomTree == NULL)
				continue;
			
			// Parse the tree
			BOMTreeIterator	bomIterator = BOMTreeIteratorNew(bomTree, NULL, NULL, NULL);
			while(!BOMTreeIteratorIsAtEnd(bomIterator))
			{
				// Get the key
				void * key = BOMTreeIteratorKey(bomIterator);
				size_t keySize = BOMTreeIteratorKeySize(bomIterator);
				NSData * keyData = [NSData dataWithBytes:key length:keySize];
				
				BOOL isValidString = YES;
				NSString *keyString = [[NSString alloc] initWithData:keyData encoding:NSASCIIStringEncoding];
				if([keyString length] == [keyData length])
				{
					for(NSUInteger characterIndex = 0 ; characterIndex < [keyString length] ; characterIndex++)
					{
						unichar theChar = [keyString characterAtIndex:characterIndex];
						isValidString &= isprint(theChar);
						if(!isValidString)
						{
							break;
						}
					}
				}
				else
				{
					isValidString = NO;
				}
				
				// Get the value associated to the key
				void * value = BOMTreeIteratorValue(bomIterator);
				size_t valueSize = BOMTreeIteratorValueSize(bomIterator);
				NSData *valueData = [NSData dataWithBytes:value length:valueSize];
				
				if(isValidString)
				{
					fprintf(stderr, "\t Key '%s' -> %s\n", [keyString UTF8String], [[valueData description] UTF8String]);
				}
				else
				{
					fprintf(stderr, "\t Key '%s' -> %s\n", [[keyData description] UTF8String], [[valueData description] UTF8String]);
				}
				
				// Next item in the tree
				BOMTreeIteratorNext(bomIterator);
			}
		}
	}
	
	return 0;
}
