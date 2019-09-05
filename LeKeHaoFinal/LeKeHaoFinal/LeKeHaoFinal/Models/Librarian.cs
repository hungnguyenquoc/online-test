using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LeKeHaoFinal.Models
{
    [Table("LIBRARIANS")]
    public class Librarian
    {
        [Key]
        public int LIB_ID { get; set; }
        [MaxLength(100)]
        public string ACCOUNT { get; set; }
  
        public string PASSWORD { get; set; }
        [MaxLength(100)]
        public string FULLNAME { get; set; }

        public Boolean GENDER { get; set; }

        [MaxLength(100)]
        public string EMAIL { get; set; }

        [MaxLength(50)]
        public string PHONE { get; set; }


        public DateTime CREATEDDATE { get; set; }

        public int CREATEDBY { get; set; }

    }
}
