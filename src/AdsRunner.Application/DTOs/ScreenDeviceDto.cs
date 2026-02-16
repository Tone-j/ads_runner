namespace AdsRunner.Application.DTOs;

public class ScreenDeviceDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string VehiclePlate { get; set; } = string.Empty;
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime LastSeen { get; set; }
    public string FirmwareVersion { get; set; } = string.Empty;
    public List<Guid> AssignedCampaignIds { get; set; } = new();
}
