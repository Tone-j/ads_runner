using AdsRunner.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AdsRunner.Infrastructure.Persistence.Configurations;

public class MediaAssetConfiguration : IEntityTypeConfiguration<MediaAsset>
{
    public void Configure(EntityTypeBuilder<MediaAsset> builder)
    {
        builder.ToTable("MediaAssets");

        builder.HasKey(m => m.Id);
        builder.Property(m => m.Id).HasDefaultValueSql("NEWSEQUENTIALID()");

        builder.Property(m => m.FileName)
            .IsRequired()
            .HasMaxLength(500);

        builder.Property(m => m.FileUrl)
            .IsRequired()
            .HasMaxLength(2048);

        builder.Property(m => m.FileType)
            .IsRequired()
            .HasMaxLength(50);

        builder.Property(m => m.ThumbnailUrl)
            .HasMaxLength(2048);

        builder.HasIndex(m => m.CampaignId);
    }
}
