using AdsRunner.Domain.Common;
using AdsRunner.Domain.Enums;

namespace AdsRunner.Domain.Entities;

public class Campaign : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public CampaignStatus Status { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public decimal Budget { get; set; }
    public int Impressions { get; set; }
    public int Reach { get; set; }
    public string? ThumbnailUrl { get; set; }

    // Foreign keys
    public Guid UserId { get; set; }

    // Navigation properties
    public User User { get; set; } = null!;
    public ICollection<MediaAsset> MediaAssets { get; set; } = new List<MediaAsset>();
    public ICollection<CampaignRegion> CampaignRegions { get; set; } = new List<CampaignRegion>();
    public ICollection<CampaignScreen> CampaignScreens { get; set; } = new List<CampaignScreen>();
}
