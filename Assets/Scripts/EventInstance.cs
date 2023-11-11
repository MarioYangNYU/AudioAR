using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Event_Instance : MonoBehaviour
{
    public FMODUnity.EventReference BirdEvent;
    public bool debug = false;

    private FMOD.Studio.EventInstance bird_event_instance;
    private float timer = 0.0f;

    void Start()
    {
        bird_event_instance = FMODUnity.RuntimeManager.CreateInstance(BirdEvent);
        FMODUnity.RuntimeManager.AttachInstanceToGameObject(bird_event_instance, gameObject.transform);
    }

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;
        if (timer > 4.0f)
        {
            PlayBirdSound();
            timer = 0.0f;
        }
    }

    private void PlayBirdSound()
    {
        bird_event_instance.start();
    }

    private void OnDrawGizmos()
    {
        if (debug)
        {
            FMOD.Studio.PLAYBACK_STATE state;
            bird_event_instance.getPlaybackState(out state);
            if (state == FMOD.Studio.PLAYBACK_STATE.PLAYING)
            {
                Gizmos.color = Color.green;
                Gizmos.DrawSphere(transform.position, 0.3f);
            }
            else
            {
                Gizmos.color = Color.yellow;
                Gizmos.DrawSphere(transform.position, 0.25f);
            }
        }
    }
}