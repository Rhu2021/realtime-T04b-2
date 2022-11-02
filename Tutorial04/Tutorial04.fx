//--------------------------------------------------------------------------------------
// File: Tutorial04.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register( b0 )
{
	matrix World;
	matrix View;
	matrix Projection;
    //add float4 type element to the cbuffer; The order is the same as the order of the elements in ConstantBuffer in CPP file
    float4 lightPos;
}

//--------------------------------------------------------------------------------------
struct VS_OUTPUT
{
    float4 Pos : SV_POSITION;
    float4 Color : COLOR0;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
// 8. specify the vertex shader input. Each argument in the input list 
//must be followed with a semantic you defined in the structure
// “D3D11_INPUT_ELEMENT_DESC layout[]”.
//old VS_OUTPUT VS
//VS_OUTPUT VS( float4 Pos : POSITION, float4 Color : COLOR )
VS_OUTPUT VS( float4 Pos : POSITION, float4 Color : COLOR, float3 N : NORMAL )
{
    VS_OUTPUT output = (VS_OUTPUT)0;
    output.Pos = mul( Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
    //
    output.Color = Color;
    //10.In the vertex shader, apply the point-light illuminate equation to calculate light colour at  each vertex.
    float4 materialAmb = float4(0.1, 0.2, 0.2, 1.0);
    float4 materialDiff = float4(0.9, 0.7, 1.0, 1.0);
    float4 lightCol = float4(1.0, 0.6, 0.8, 1.0);
    float3 lightDir = normalize(lightPos.xyz - Pos.xyz);
    float3 normal = normalize(N);
    float diff = max(0.0, dot(lightDir, normal));
    output.Color = (materialAmb + diff * materialDiff) * lightCol;
    //10

    return output;
}

VS_OUTPUT VS_main(float4 Pos : POSITION, float4 Color : COLOR)
{
    VS_OUTPUT output = (VS_OUTPUT)0;
    //output.Pos = mul(Pos, World);
    float4 inPos = Pos;
    inPos += float4(2.0, 0.3, 1.0, 0.0);
    inPos *= float4(0.2, 3.0, 3.0, 1.0);
    output.Pos = inPos;
    /*float4 inPos = Pos;
    output.Pos = inPos + (float4)(1.0, 0.3, 1.0, 0.0);
    output.Pos = inPos * (float4)(0.2,3.0,3.0, 0.0);*/
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
    output.Color = Color;
    return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
    return input.Color;
}


