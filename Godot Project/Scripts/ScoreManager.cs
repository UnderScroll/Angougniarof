using Godot;
using Godot.NativeInterop;
using System;
using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using System.Text;

public partial class ScoreManager : Node
{
	[Export] private TextureRect sourceTex = null;
	[Export] private TextureRect outputTex = null;
	[Export] private RenderingDevice.DataFormat texFormat = RenderingDevice.DataFormat.R8G8B8A8Unorm;
    [Export] private float threshold = 0.2f;
    private float sum = 0;
	private float totalPixel = 0;

	private RenderingDevice rd;

	private Texture2D tex1;
	private Texture2D tex2;
	private byte[] paramByte;

	private Rid paramRid;
	private Rid tex1Rid;
	private Rid tex2Rid;
	private Rid uniformSet;
	private Rid pipeline;

	public void _on_button_pressed()
	{
		tex1 = sourceTex.Texture;
	}
	public void _on_button_2_pressed()
	{
		tex2 = sourceTex.Texture;
	}
	public void _on_do_pressed()
	{
		ManageCShader();
	}

	private void InitGPU()
	{
		if (sourceTex == null)
			throw new ArgumentException("Null reference exception img1 isn't assigned in ScoreManager");

		rd = RenderingServer.CreateLocalRenderingDevice();

		var shaderFile = GD.Load<RDShaderFile>("res://Scripts/CompareShader.glsl");
		var shaderBytecode = shaderFile.GetSpirV();
		var shader = rd.ShaderCreateFromSpirV(shaderBytecode);

		
		float[] input = { threshold, 0,0,0};
		paramByte = new byte[input.Length * sizeof(float)];
		Buffer.BlockCopy(input, 0, paramByte, 0, paramByte.Length);
		paramRid = rd.StorageBufferCreate((uint)paramByte.Length, paramByte);

		var parameterUniform = new RDUniform();
		parameterUniform.UniformType = RenderingDevice.UniformType.StorageBuffer;
		parameterUniform.Binding = 2;
		parameterUniform.AddId(paramRid);



		uniformSet = rd.UniformSetCreate(new Godot.Collections.Array<RDUniform> { 
			SetUpTex(tex1, ref tex1Rid, 0), 
			SetUpTex(tex2, ref tex2Rid,1),
			parameterUniform}, shader, (uint)0);

		pipeline = rd.ComputePipelineCreate(shader);

	}
	private RDUniform SetUpTex(Texture2D tex, ref Rid texRid, int binding) 
	{
		var format = new RDTextureFormat();
		format.Format = texFormat;
		format.Width = (uint)tex.GetWidth();
		format.Height = (uint)tex.GetHeight();
		format.UsageBits = RenderingDevice.TextureUsageBits.StorageBit | RenderingDevice.TextureUsageBits.CanUpdateBit | RenderingDevice.TextureUsageBits.CanCopyFromBit;

		texRid = rd.TextureCreate(format, new RDTextureView());

		var texUniform = new RDUniform();
		texUniform.UniformType = RenderingDevice.UniformType.Image;
		texUniform.Binding = binding;  // This matches the binding in the shader.
		texUniform.AddId(texRid);
		return texUniform;
	}

	private void ManageCShader()
	{
		if (rd == null)
			InitGPU();
		Stopwatch watch = Stopwatch.StartNew();
        sum = 0;
        UpdateTex(tex1, ref tex1Rid);
		UpdateTex(tex2, ref tex2Rid);


		//float[] input = { accuracy, 0, 0, 0 };
		//Buffer.BlockCopy(input, 0, paramByte, 0, paramByte.Length);
		//rd.BufferUpdate(paramRid, 0, (uint)paramByte.Length, paramByte);

		var computeList = rd.ComputeListBegin();
		rd.ComputeListBindComputePipeline(computeList, pipeline);
		rd.ComputeListBindUniformSet(computeList, uniformSet, 0);
		rd.ComputeListDispatch(computeList, (uint)tex1.GetWidth() / 16, (uint)tex1.GetHeight() / 9, zGroups: 1);
		rd.ComputeListEnd();

		// Submit to GPU and wait for sync
		rd.Submit();
		rd.Sync();


        var paramBufferOut = rd.BufferGetData(paramRid);
        var paramOut = new float[4];
        Buffer.BlockCopy(paramBufferOut, 0, paramOut, 0, paramBufferOut.Length);

        

        var outputBytes = rd.TextureGetData(tex1Rid, 0);
		var outImage = Image.CreateFromData(tex1.GetWidth(), tex1.GetHeight(), false, Image.Format.Rgba8, outputBytes);

        uint diff = 0;
		uint pixelCount = 0;
        byte[] data = outImage.GetData();

        for (uint i =0; i < outImage.GetDataSize(); i+=4)
		{
			pixelCount ++;
            if (data[i] <= 255){
				diff += data[i];
			}
		}
		GD.Print(((float)diff /(pixelCount * 255)*100) + "% in : " + watch.ElapsedMilliseconds + "ms" );
		outputTex.Texture = ImageTexture.CreateFromImage(outImage);
    }
	private void UpdateTex(Texture2D tex, ref Rid texRid) 
	{
		var origin = tex.GetImage();
		if (origin.GetFormat() != Image.Format.Rgba8)
		{
			origin.Convert(Image.Format.Rgba8);
		}
		rd.TextureUpdate(texRid, 0, origin.GetData());
	}
	public override void _Ready()
	{

	}
}
