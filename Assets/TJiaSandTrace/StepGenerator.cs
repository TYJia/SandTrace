using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class StepGenerator : MonoBehaviour {

    public RenderTexture StepRT;
    public RenderTexture mTmpRT;
    public Material StepMat;

    private Vector3 LastPlayerPos;
	void OnEnable () {
        mTmpRT = RenderTexture.GetTemporary(StepRT.descriptor);
        LastPlayerPos = transform.position;

    }

    void OnDisable()
    {
        RenderTexture.ReleaseTemporary(mTmpRT);
        mTmpRT = null;
        Graphics.Blit(mTmpRT, StepRT, StepMat, 1);
    }
	
	void Update () {
        Shader.SetGlobalVector("_PlayerPos", transform.position);
        if (Vector3.Distance(transform.position, LastPlayerPos) > 0.001f)
        {
            StepMat.SetVector("_DeltaPos", transform.position - LastPlayerPos);
            Graphics.Blit(StepRT, mTmpRT);
            Graphics.Blit(mTmpRT, StepRT, StepMat, 0);
            LastPlayerPos = transform.position;
        }
	}
}
