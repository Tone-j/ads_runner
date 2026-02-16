using AdsRunner.Domain.Common;
using AdsRunner.Domain.Enums;

namespace AdsRunner.Domain.Entities;

public class CampaignRegion : BaseEntity
{
    public RegionType RegionType { get; set; }

    // Foreign keys
    public Guid CampaignId { get; set; }

    // Navigation properties
    public Campaign Campaign { get; set; } = null!;
}
