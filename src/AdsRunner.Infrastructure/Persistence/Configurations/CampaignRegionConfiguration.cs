using AdsRunner.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AdsRunner.Infrastructure.Persistence.Configurations;

public class CampaignRegionConfiguration : IEntityTypeConfiguration<CampaignRegion>
{
    public void Configure(EntityTypeBuilder<CampaignRegion> builder)
    {
        builder.ToTable("CampaignRegions");

        builder.HasKey(cr => cr.Id);
        builder.Property(cr => cr.Id).HasDefaultValueSql("NEWSEQUENTIALID()");

        builder.Property(cr => cr.RegionType)
            .IsRequired()
            .HasConversion<string>()
            .HasMaxLength(30);

        builder.HasIndex(cr => cr.CampaignId);
        builder.HasIndex(cr => new { cr.CampaignId, cr.RegionType }).IsUnique();
    }
}
