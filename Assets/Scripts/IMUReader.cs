using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices.ComTypes;
using Uduino;
using UnityEngine;

public class IMUReader : MonoBehaviour
{
    public string stringData = "0,0,0";
    public Vector3 targetAngle = Vector3.zero;

    public Transform target;

    void Awake()
    {
        UduinoManager.Instance.alwaysRead = true;
    }

    void OnEnable()
    {
        UduinoManager.Instance.OnDataReceived += OnDataReceived;
    }

    void OnDisable()
    {

        UduinoManager.Instance.OnDataReceived -= OnDataReceived;
    }

    void OnDataReceived(string data, UduinoDevice deviceName)
    {
        data = data.Trim();
        Debug.Log("Data received: " + data);

        string[] parts = data.Split(' ');

        if (parts.Length == 3 && float.TryParse(parts[0], out float x)
            && float.TryParse(parts[1], out float y)
            && float.TryParse(parts[2], out float z))
        {
            targetAngle = new Vector3(x, y, z);
            target.eulerAngles = targetAngle;
        }
        else
        {
            Debug.LogWarning("Invalid data format: " + data);
        }
    }
}
