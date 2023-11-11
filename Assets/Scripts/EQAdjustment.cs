using FMODUnity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EQAdjustment : MonoBehaviour
{
    private FMOD.Studio.EventInstance instance;
    private FMOD.Studio.PARAMETER_ID EQparameterID;

    public StudioEventEmitter emitter;

    public float divisionFactor = 10f;

    public float zMax;

    public EventReference fmodEvent;

    public Transform listener;

    [Range(-1f, 1f)]
    public float eqVal;

    [Range(0, 1f)]
    public float volume = 0.8f;

    void Start()
    {
        emitter = GetComponent<StudioEventEmitter>();
        listener = FindObjectOfType<StudioListener>().transform;

        zMax = emitter.OverrideMaxDistance;

        instance = FMODUnity.RuntimeManager.CreateInstance(fmodEvent);

        instance.start();
    }

    void Update()
    {

        float zDistance = transform.position.z - listener.position.z;
        Debug.Log(zDistance);

        eqVal = zDistance.Remap(-zMax / divisionFactor, zMax / divisionFactor, -1, 1);

        FMODUnity.RuntimeManager.StudioSystem.setParameterByName("EQ", eqVal);

        FMODUnity.RuntimeManager.StudioSystem.setParameterByName("Volume", volume);

    }

}


