drop table if exists activity_submission                    cascade;
drop table if exists activity_submission_water_quality      cascade;
drop table if exists aquifer                                cascade;
drop table if exists aquifer_demand_code                    cascade;
drop table if exists aquifer_material_code                  cascade;
drop table if exists aquifer_productivity_code              cascade;
drop table if exists aquifer_subtype_code                   cascade;
drop table if exists aquifer_vulnerability_code             cascade;
drop table if exists aquifer_well                           cascade;
drop table if exists auth_group                             cascade;
drop table if exists auth_group_permissions                 cascade;
drop table if exists auth_permission                        cascade;
drop table if exists auth_user                              cascade;
drop table if exists auth_user_groups                       cascade;
drop table if exists auth_user_user_permissions             cascade;
drop table if exists bcgs_number                            cascade;
drop table if exists bedrock_material_code                  cascade;
drop table if exists bedrock_material_descriptor_code       cascade;
drop table if exists casing                                 cascade;
drop table if exists casing_code                            cascade;
drop table if exists casing_material_code                   cascade;
drop table if exists decommission_method_code               cascade;
drop table if exists development_method_code                cascade;
drop table if exists django_admin_log                       cascade;
drop table if exists django_content_type                    cascade;
drop table if exists django_migrations                      cascade;
drop table if exists django_session                         cascade;
drop table if exists drilling_company                       cascade;
drop table if exists drilling_method_code                   cascade;
drop table if exists filter_pack_material_code              cascade;
drop table if exists filter_pack_material_size_code         cascade;
drop table if exists ground_elevation_method_code           cascade;
drop table if exists gwells_survey                          cascade;
drop table if exists hydraulic_property                     cascade;
drop table if exists intended_water_use_code                cascade;
drop table if exists land_district_code                     cascade;
drop table if exists licenced_status_code                   cascade;
drop table if exists liner_material_code                    cascade;
drop table if exists liner_perforation                      cascade;
drop table if exists lithology_colour_code                  cascade;
drop table if exists lithology_description                  cascade;
drop table if exists lithology_description_code             cascade;
drop table if exists lithology_hardness_code                cascade;
drop table if exists lithology_material_code                cascade;
drop table if exists lithology_moisture_code                cascade;
drop table if exists lithology_structure_code               cascade;
drop table if exists ltsa_owner                             cascade;
drop table if exists obs_well_status_code                   cascade;
drop table if exists online_survey                          cascade;
drop table if exists perforation                            cascade;
drop table if exists production_data                        cascade;
drop table if exists profile                                cascade;
drop table if exists province_state_code                    cascade;
drop table if exists quality_concern_code                   cascade;
drop table if exists registries_accredited_certificate_code cascade;
drop table if exists registries_activity_code               cascade;
drop table if exists registries_application                 cascade;
drop table if exists registries_application_status_code     cascade;
drop table if exists registries_certifying_authority_code   cascade;
drop table if exists registries_organization                cascade;
drop table if exists registries_organization_note           cascade;
drop table if exists registries_person                      cascade;
drop table if exists registries_person_note                 cascade;
drop table if exists registries_proof_of_age_code           cascade;
drop table if exists registries_register                    cascade;
drop table if exists registries_register_note               cascade;
drop table if exists registries_removal_reason_code         cascade;
drop table if exists registries_subactivity_code            cascade;
drop table if exists registries_well_class_code             cascade;
drop table if exists registries_well_qualification          cascade;
drop table if exists reversion_revision                     cascade;
drop table if exists reversion_version                      cascade;
drop table if exists screen                                 cascade;
drop table if exists screen_assembly_type_code              cascade;
drop table if exists screen_bottom_code                     cascade;
drop table if exists screen_intake_method_code              cascade;
drop table if exists screen_material_code                   cascade;
drop table if exists screen_opening_code                    cascade;
drop table if exists screen_type_code                       cascade;
drop table if exists surface_seal_material_code             cascade;
drop table if exists surface_seal_method_code               cascade;
drop table if exists surficial_material_code                cascade;
drop table if exists water_quality_characteristic           cascade;
drop table if exists water_quality_colour_code              cascade;
drop table if exists water_use_code                         cascade;
drop table if exists well                                   cascade;
drop table if exists well_activity_code                     cascade;
drop table if exists well_class_code                        cascade;
drop table if exists well_status_code                       cascade;
drop table if exists well_subclass_code                     cascade;
drop table if exists well_water_quality                     cascade;
drop table if exists well_yield_unit_code                   cascade;
drop table if exists wells_decommissiondescription          cascade;
drop table if exists wells_decommissionmaterialcode         cascade;
drop table if exists xform_aquifers                         cascade;
drop table if exists yield_estimation_method_code           cascade;
drop function if exists db_replicate_step1                (boolean);
drop function if exists db_replicate_step2                       ();
drop function if exists migrate_aquifers                         ();
drop function if exists migrate_bcgs                             ();
drop function if exists migrate_casings                          ();
drop function if exists migrate_lithology                        ();
drop function if exists migrate_perforations                     ();
drop function if exists migrate_production                       ();
drop function if exists migrate_screens                          ();
drop function if exists populate_well                            ();
drop function if exists populate_xform                    (boolean);
