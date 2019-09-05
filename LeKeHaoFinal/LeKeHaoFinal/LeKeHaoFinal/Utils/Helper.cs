using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace LeKeHaoFinal.Utils
{
    public class Helper
    {
        public static readonly string AppKey = "1234567890123456";
        public static readonly string Issuer = "abc.com";
        public static string GenHash(string input)
        {
            return string.Join("", new SHA1Managed().ComputeHash(Encoding.UTF8.GetBytes(input))
                .Select(x => x.ToString("X2")).ToArray());
        }
        public static string GetBaseUrl(HttpRequest request)
        {
            return request.Scheme + "://" + request.Host.ToString();
        }


    }
}
