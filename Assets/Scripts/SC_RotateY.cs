using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SC_RotateY : MonoBehaviour
{
    public float rotateSpeed = 1f;

    void Start()
    {

    }

    void Update()
    {
        transform.Rotate(0f, rotateSpeed * Time.deltaTime, 0f);

    }
}
