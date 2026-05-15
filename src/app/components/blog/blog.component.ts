import { AfterViewInit, Component, ElementRef, NgZone, OnDestroy } from '@angular/core';
import hljs from 'highlight.js/lib/core';
import java from 'highlight.js/lib/languages/java';
import sql from 'highlight.js/lib/languages/sql';
import typescript from 'highlight.js/lib/languages/typescript';
import ini from 'highlight.js/lib/languages/ini';

hljs.registerLanguage('java', java);
hljs.registerLanguage('sql', sql);
hljs.registerLanguage('typescript', typescript);
hljs.registerLanguage('ini', ini);

@Component({
  selector: 'app-blog',
  standalone: false,
  templateUrl: './blog.component.html',
  styleUrl: './blog.component.css'
})
export class BlogComponent implements AfterViewInit, OnDestroy {
  private mutationObserver?: MutationObserver;

  constructor(
    private readonly host: ElementRef<HTMLElement>,
    private readonly ngZone: NgZone
  ) {}

  ngAfterViewInit(): void {
    this.highlightUnprocessedBlocks();

    this.ngZone.runOutsideAngular(() => {
      this.mutationObserver = new MutationObserver(() => {
        this.highlightUnprocessedBlocks();
      });

      this.mutationObserver.observe(this.host.nativeElement, {
        childList: true,
        subtree: true
      });
    });
  }

  ngOnDestroy(): void {
    this.mutationObserver?.disconnect();
  }

  private highlightUnprocessedBlocks(): void {
    const blocks = this.host.nativeElement.querySelectorAll(
      'pre.blog-code-block code[class*="language-"]:not(.hljs)'
    );

    blocks.forEach((block) => {
      hljs.highlightElement(block as HTMLElement);
    });
  }
}
