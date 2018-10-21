//
//  Bom.h
//  CARParser
//
//  Created by Alexandre Colucci.
//  Copyright © 2018 Timac. All rights reserved.
//

#pragma once

typedef uint32_t BOMBlockID;
typedef struct BOMStorage *BOMStorage;

typedef struct BOMTree *BOMTree;
typedef struct BOMTreeIterator *BOMTreeIterator;

// Opening a BOM
BOMStorage BOMStorageOpen(const char *inPath, Boolean inWriting);

// Accessing a BOM block
BOMBlockID BOMStorageGetNamedBlock(BOMStorage inStorage, const char *inName);
size_t BOMStorageSizeOfBlock(BOMStorage inStorage, BOMBlockID inBlockID);
int BOMStorageCopyFromBlock(BOMStorage inStorage, BOMBlockID inBlockID, void *outData);

// Accessing a BOM tree
BOMTree BOMTreeOpenWithName(BOMStorage inStorage, const char *inName, Boolean inWriting);
BOMTreeIterator BOMTreeIteratorNew(BOMTree inTree, void *, void *, void *);
Boolean BOMTreeIteratorIsAtEnd(BOMTreeIterator iterator);
void BOMTreeIteratorNext(BOMTreeIterator iterator);

// Accessing the keys and values of a BOM tree
void * BOMTreeIteratorKey(BOMTreeIterator iterator);
size_t BOMTreeIteratorKeySize(BOMTreeIterator iterator);
void * BOMTreeIteratorValue(BOMTreeIterator iterator);
size_t BOMTreeIteratorValueSize(BOMTreeIterator iterator);
