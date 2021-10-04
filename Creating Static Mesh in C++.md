Code review feedback fixes and render data import unit test.

# Creating Static Mesh in C++

This example shows how to convert a Procedural Mesh to a Static Mesh.

Based on https://github.com/linqingwudiv1/RuntimeMeshLoaderExtend.

```cpp
FMeshDescription BuildMeshDescriptionEx(UProceduralMeshComponent* ProcMeshComp)
{
	FMeshDescription MeshDescription;

	FStaticMeshAttributes AttributeGetter(MeshDescription);
	AttributeGetter.Register();

	TPolygonGroupAttributesRef<FName> PolygonGroupNames = AttributeGetter.GetPolygonGroupMaterialSlotNames();
	TVertexAttributesRef<FVector> VertexPositions = AttributeGetter.GetVertexPositions();
	TVertexInstanceAttributesRef<FVector> Tangents = AttributeGetter.GetVertexInstanceTangents();
	TVertexInstanceAttributesRef<float> BinormalSigns = AttributeGetter.GetVertexInstanceBinormalSigns();
	TVertexInstanceAttributesRef<FVector> Normals = AttributeGetter.GetVertexInstanceNormals();
	TVertexInstanceAttributesRef<FVector4> Colors = AttributeGetter.GetVertexInstanceColors();
	TVertexInstanceAttributesRef<FVector2D> UVs = AttributeGetter.GetVertexInstanceUVs();

	const int32 NumSections = ProcMeshComp->GetNumSections();
	int32 VertexCount = 0;
	int32 VertexInstanceCount = 0;
	int32 PolygonCount = 0;

	TMap<UMaterialInterface*, FPolygonGroupID> UniqueMaterials = BuildMaterialMapEx(ProcMeshComp, MeshDescription);
	TArray<FPolygonGroupID> PolygonGroupForSection;
	PolygonGroupForSection.Reserve(NumSections);

	// Calculate the totals for each ProcMesh element type
	for (int32 SectionIdx = 0; SectionIdx < NumSections; SectionIdx++)
	{
		FProcMeshSection* ProcSection =
			ProcMeshComp->GetProcMeshSection(SectionIdx);
		VertexCount += ProcSection->ProcVertexBuffer.Num();
		VertexInstanceCount += ProcSection->ProcIndexBuffer.Num();
		PolygonCount += ProcSection->ProcIndexBuffer.Num() / 3;
	}
	MeshDescription.ReserveNewVertices(VertexCount);
	MeshDescription.ReserveNewVertexInstances(VertexInstanceCount);
	MeshDescription.ReserveNewPolygons(PolygonCount);
	MeshDescription.ReserveNewEdges(PolygonCount * 2);
	UVs.SetNumIndices(4);

	// Create the Polygon Groups
	for (int32 SectionIdx = 0; SectionIdx < NumSections; SectionIdx++)
	{
		FProcMeshSection* ProcSection =
			ProcMeshComp->GetProcMeshSection(SectionIdx);
		UMaterialInterface* Material = ProcMeshComp->GetMaterial(SectionIdx);
		FPolygonGroupID* PolygonGroupID = UniqueMaterials.Find(Material);
		check(PolygonGroupID != nullptr);
		PolygonGroupForSection.Add(*PolygonGroupID);
	}


	// Add Vertex and VertexInstance and polygon for each section
	for (int32 SectionIdx = 0; SectionIdx < NumSections; SectionIdx++)
	{
		FProcMeshSection* ProcSection =
			ProcMeshComp->GetProcMeshSection(SectionIdx);
		FPolygonGroupID PolygonGroupID = PolygonGroupForSection[SectionIdx];
		// Create the vertex
		int32 NumVertex = ProcSection->ProcVertexBuffer.Num();
		TMap<int32, FVertexID> VertexIndexToVertexID;
		VertexIndexToVertexID.Reserve(NumVertex);

		for (int32 VertexIndex = 0; VertexIndex < NumVertex; ++VertexIndex)
		{
			FProcMeshVertex& Vert = ProcSection->ProcVertexBuffer[VertexIndex];
			const FVertexID VertexID = MeshDescription.CreateVertex();
			VertexPositions[VertexID] = Vert.Position;
			VertexIndexToVertexID.Add(VertexIndex, VertexID);
		}
		// Create the VertexInstance
		int32 NumIndices = ProcSection->ProcIndexBuffer.Num();
		int32 NumTri = NumIndices / 3;
		TMap<int32, FVertexInstanceID> IndiceIndexToVertexInstanceID;
		IndiceIndexToVertexInstanceID.Reserve(NumVertex);
		for (int32 IndiceIndex = 0; IndiceIndex < NumIndices; IndiceIndex++)
		{
			const int32 VertexIndex = ProcSection->ProcIndexBuffer[IndiceIndex];
			const FVertexID VertexID = VertexIndexToVertexID[VertexIndex];
			const FVertexInstanceID VertexInstanceID =
				MeshDescription.CreateVertexInstance(VertexID);
			IndiceIndexToVertexInstanceID.Add(IndiceIndex, VertexInstanceID);

			FProcMeshVertex& ProcVertex = ProcSection->ProcVertexBuffer[VertexIndex];

			Tangents[VertexInstanceID] = ProcVertex.Tangent.TangentX;
			Normals[VertexInstanceID] = ProcVertex.Normal;
			BinormalSigns[VertexInstanceID] =
				ProcVertex.Tangent.bFlipTangentY ? -1.f : 1.f;

			Colors[VertexInstanceID] = FLinearColor(ProcVertex.Color);

			UVs.Set(VertexInstanceID, 0, ProcVertex.UV0);
			UVs.Set(VertexInstanceID, 1, ProcVertex.UV1);
			UVs.Set(VertexInstanceID, 2, ProcVertex.UV2);
			UVs.Set(VertexInstanceID, 3, ProcVertex.UV3);
		}

		// Create the polygons for this section
		for (int32 TriIdx = 0; TriIdx < NumTri; TriIdx++)
		{
			FVertexID VertexIndexes[3];
			TArray<FVertexInstanceID> VertexInstanceIDs;
			VertexInstanceIDs.SetNum(3);

			for (int32 CornerIndex = 0; CornerIndex < 3; ++CornerIndex)
			{
				const int32 IndiceIndex = (TriIdx * 3) + CornerIndex;
				const int32 VertexIndex = ProcSection->ProcIndexBuffer[IndiceIndex];
				VertexIndexes[CornerIndex] = VertexIndexToVertexID[VertexIndex];
				VertexInstanceIDs[CornerIndex] =
					IndiceIndexToVertexInstanceID[IndiceIndex];
			}

			// Insert a polygon into the mesh
			MeshDescription.CreatePolygon(PolygonGroupID, VertexInstanceIDs);
		}
	}
	return MeshDescription;
}

UStaticMesh* ASplineMesh::LoadMeshToStaticMeshFromProceduralMesh(UObject* WorldContextObject, UProceduralMeshComponent* ProcMeshComp)
{

	FString NewNameSuggestion = FString(TEXT("ProcMesh"));
	FString PackageName = FString(TEXT("/Game/Meshes/")) + NewNameSuggestion;
	FString Name;
	FString UserPackageName = TEXT("");

	// FAssetToolsModule& AssetToolsModule = FModuleManager::LoadModuleChecked<FAssetToolsModule>("AssetTools");
	// AssetToolsModule.Get().CreateUniqueAssetName(PackageName, TEXT(""), PackageName, Name);

	FName MeshName(*FPackageName::GetLongPackageAssetName(UserPackageName));

	// FName MeshName( *FPackageName::GetLongPackageAssetName( UserPackageName ) );
	// Check if the user inputed a valid asset name, if they did not, give it the generated default name
	if (MeshName == NAME_None)
	{
		// Use the defaults that were already generated.
		UserPackageName = PackageName;
		MeshName = *Name;
	}

	FMeshDescription MeshDescription = BuildMeshDescriptionEx(ProcMeshComp);

	UStaticMesh* StaticMesh = NewObject<UStaticMesh>(WorldContextObject, MeshName, RF_Public | RF_Standalone);

	StaticMesh->InitResources();
	StaticMesh->LightingGuid = FGuid::NewGuid();

	TArray<const FMeshDescription*> arr;

	arr.Add(&MeshDescription);
	UStaticMesh::FBuildMeshDescriptionsParams MyParams;
	MyParams.bBuildSimpleCollision = false;
	MyParams.bBuildSimpleCollision = true;
	MyParams.bMarkPackageDirty = true;
	MyParams.bUseHashAsGuid = false;
	StaticMesh->BuildFromMeshDescriptions(arr, MyParams);

	//// MATERIALS
	TSet<UMaterialInterface*> UniqueMaterials;

	const int32 NumSections = 1;
	for (int32 SectionIdx = 0; SectionIdx < NumSections; SectionIdx++)
	{
		UMaterialInterface* Material = UMaterial::GetDefaultMaterial(MD_Surface);
		UniqueMaterials.Add(Material);
	}

#pragma region material test
	for (UMaterialInterface* Material : UniqueMaterials)
	{
		// Material
		FStaticMaterial&& StaticMat = FStaticMaterial(Material);

		StaticMat.UVChannelData.bInitialized = true;
		StaticMesh->StaticMaterials.Add(StaticMat);

	}
#pragma region FMeshSectionInfo

	FStaticMeshRenderData* const RenderData = StaticMesh->RenderData.Get();


	int32 LODIndex = 0;
	int32 MaxLODs = RenderData->LODResources.Num();
	for (int32 MaterialID = 0; LODIndex < MaxLODs; ++LODIndex)
	{
		FStaticMeshLODResources& LOD = RenderData->LODResources[LODIndex];

		for (int32 SectionIndex = 0; SectionIndex < LOD.Sections.Num(); ++SectionIndex)
		{
			FStaticMeshSection& Section = LOD.Sections[SectionIndex];
			Section.MaterialIndex = MaterialID;
			Section.bEnableCollision = true;
			Section.bCastShadow = true;
			Section.bForceOpaque = false;
			MaterialID++;
		}
	}

#pragma endregion 




#pragma endregion material test

	//StaticMesh->Build(false);
	return StaticMesh;
}
```