namespace AdsRunner.Application.DTOs;

public class CampaignDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public decimal Budget { get; set; }
    public int Impressions { get; set; }
    public int Reach { get; set; }
    public string? ThumbnailUrl { get; set; }
    public List<string> TargetRegions { get; set; } = new();
    public List<MediaAssetDto> MediaAssets { get; set; } = new();
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
