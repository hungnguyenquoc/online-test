using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LeKeHaoFinal.Models
{
    [Table("CHECKOUTS ")]
    public class Checkout
    {
        [Key]
        public long CHK_ID { get; set; }

        public int LIB_ID { get; set; }
        [ForeignKey("LIB_ID")]
        public virtual Librarian Librarian { get; set; }

        public int MEM_ID { get; set; }
        [ForeignKey("MEM_ID")]
        public virtual Member Member { get; set; }

        public DateTime CREATEDDATE { get; set; }

        public int CREATEDBY { get; set; }
    }
}
