using AdsRunner.Domain.Common;
using AdsRunner.Domain.Enums;

namespace AdsRunner.Domain.Entities;

public class ScreenDevice : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string VehiclePlate { get; set; } = string.Empty;
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public ScreenStatus Status { get; set; }
    public DateTime LastSeen { get; set; }
    public string FirmwareVersion { get; set; } = string.Empty;

    // Navigation properties
    public ICollection<CampaignScreen> CampaignScreens { get; set; } = new List<CampaignScreen>();
}
