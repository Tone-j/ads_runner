using AdsRunner.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AdsRunner.Infrastructure.Persistence.Configurations;

public class CampaignConfiguration : IEntityTypeConfiguration<Campaign>
{
    public void Configure(EntityTypeBuilder<Campaign> builder)
    {
        builder.ToTable("Campaigns");

        builder.HasKey(c => c.Id);
        builder.Property(c => c.Id).HasDefaultValueSql("NEWSEQUENTIALID()");

        builder.Property(c => c.Name)
            .IsRequired()
            .HasMaxLength(200);

        builder.Property(c => c.Description)
            .HasMaxLength(2000);

        builder.Property(c => c.Status)
            .IsRequired()
            .HasConversion<string>()
            .HasMaxLength(20);

        builder.Property(c => c.Budget)
            .HasPrecision(18, 2);

        builder.Property(c => c.ThumbnailUrl)
            .HasMaxLength(2048);

        builder.HasIndex(c => c.UserId);
        builder.HasIndex(c => c.Status);

        builder.HasMany(c => c.MediaAssets)
            .WithOne(m => m.Campaign)
            .HasForeignKey(m => m.CampaignId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(c => c.CampaignRegions)
            .WithOne(cr => cr.Campaign)
            .HasForeignKey(cr => cr.CampaignId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasMany(c => c.CampaignScreens)
            .WithOne(cs => cs.Campaign)
            .HasForeignKey(cs => cs.CampaignId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
