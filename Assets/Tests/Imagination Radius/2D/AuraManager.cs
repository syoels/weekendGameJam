using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AuraManager : MonoBehaviour
{

    public float radius = 200f;
    public Vector4 auraCenter = new Vector4(0, 0, 0, 0);
    

    // Start is called before the first frame update
    void Start()
    {
        // TODO: Calculate screen center in pixels and place inside auraCenter
        Shader.SetGlobalVector("_AuraCenter", auraCenter);
        Shader.SetGlobalFloat("_AuraRadius", radius);
    }

    // Update is called once per frame
    void Update()
    {
        UpdateAuraRadius(radius);
        UpdateAuraCenter(auraCenter.x, auraCenter.y);
    }

    public void UpdateAuraRadius(float new_radius) {
        this.radius = new_radius;
        Shader.SetGlobalFloat("_AuraRadius", new_radius);
    }

    public void UpdateAuraCenter(float x, float y)
    {
        this.auraCenter.x = x;
        this.auraCenter.y = y;
        Shader.SetGlobalVector("_AuraCenter", auraCenter);
    }
}
