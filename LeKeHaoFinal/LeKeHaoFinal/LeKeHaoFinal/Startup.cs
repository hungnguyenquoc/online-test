using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LeKeHaoFinal.Models;
using LeKeHaoFinal.Utils;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;


namespace LeKeHaoFinal
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IHostingEnvironment hostingEnvironment)
        {
            Configuration = configuration;
            HostingEnviroment = hostingEnvironment;
        }

        public IConfiguration Configuration { get; }

        public IHostingEnvironment HostingEnviroment { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            string connectionstring = Configuration.GetConnectionString("DefaultConnection");
            services.AddDbContext<LibContext>(options => options.UseSqlServer(connectionstring));
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2)
                            .AddJsonOptions(options => {
                                options.SerializerSettings.NullValueHandling = NullValueHandling.Ignore;
                            });

            services.AddCors(options => {
                options.AddPolicy("AllowAll",
                    builder => {
                        builder.AllowAnyOrigin()
                               .AllowAnyMethod()
                               .AllowAnyHeader()
                               .AllowCredentials();
                    });
            });

            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
               .AddJwtBearer(options =>
               {
                   options.TokenValidationParameters = new TokenValidationParameters
                   {
                       ValidateIssuer = true,
                       ValidateAudience = true,
                       ValidateIssuerSigningKey = true,
                       RequireExpirationTime = true,
                       ValidateLifetime = true,
                       ValidIssuer = Helper.Issuer,
                       ValidAudience = Helper.Issuer,
                       IssuerSigningKey = new SymmetricSecurityKey(
                                               Encoding.UTF8.GetBytes(Helper.AppKey))
                   };
               });

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            app.UseCors("AllowAll");
            app.UseAuthentication();
            app.UseMvc();
        }
    }
}
