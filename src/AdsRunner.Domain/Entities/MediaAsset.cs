using AdsRunner.Domain.Common;

namespace AdsRunner.Domain.Entities;

public class MediaAsset : BaseEntity
{
    public string FileName { get; set; } = string.Empty;
    public string FileUrl { get; set; } = string.Empty;
    public string FileType { get; set; } = string.Empty;
    public long FileSize { get; set; }
    public DateTime UploadedAt { get; set; }
    public string? ThumbnailUrl { get; set; }

    // Foreign keys
    public Guid CampaignId { get; set; }

    // Navigation properties
    public Campaign Campaign { get; set; } = null!;
}
