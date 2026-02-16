namespace AdsRunner.Application.DTOs;

public class CampaignSummaryDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public int Impressions { get; set; }
    public int Reach { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string? ThumbnailUrl { get; set; }
}
