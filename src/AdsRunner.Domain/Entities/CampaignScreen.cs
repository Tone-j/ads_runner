using AdsRunner.Domain.Common;

namespace AdsRunner.Domain.Entities;

public class CampaignScreen : BaseEntity
{
    // Foreign keys
    public Guid CampaignId { get; set; }
    public Guid ScreenDeviceId { get; set; }

    // Navigation properties
    public Campaign Campaign { get; set; } = null!;
    public ScreenDevice ScreenDevice { get; set; } = null!;
}
