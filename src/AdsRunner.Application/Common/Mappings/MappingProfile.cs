using AutoMapper;
using AdsRunner.Domain.Entities;
using AdsRunner.Application.DTOs;

namespace AdsRunner.Application.Common.Mappings;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<User, UserDto>()
            .ForMember(d => d.Role, opt => opt.MapFrom(s => s.Role.ToString()));

        CreateMap<Campaign, CampaignDto>()
            .ForMember(d => d.Status, opt => opt.MapFrom(s => s.Status.ToString()))
            .ForMember(d => d.TargetRegions, opt => opt.MapFrom(s =>
                s.CampaignRegions.Select(cr => cr.RegionType.ToString()).ToList()));

        CreateMap<Campaign, CampaignSummaryDto>()
            .ForMember(d => d.Status, opt => opt.MapFrom(s => s.Status.ToString()));

        CreateMap<MediaAsset, MediaAssetDto>();

        CreateMap<ScreenDevice, ScreenDeviceDto>()
            .ForMember(d => d.Status, opt => opt.MapFrom(s => s.Status.ToString()))
            .ForMember(d => d.AssignedCampaignIds, opt => opt.MapFrom(s =>
                s.CampaignScreens.Select(cs => cs.CampaignId).ToList()));

        CreateMap<Subscription, SubscriptionDto>()
            .ForMember(d => d.Tier, opt => opt.MapFrom(s => s.Tier.ToString()));

        CreateMap<PaymentRecord, PaymentRecordDto>()
            .ForMember(d => d.Status, opt => opt.MapFrom(s => s.Status.ToString()));
    }
}
