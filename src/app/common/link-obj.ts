export class LinkObj {
    /**
     * 
     * @param name - name of nav link item
     * @param path - path of nav link item
     * @param enable - show or hide link item
     */
    constructor(
        public name: string,
        public path: string,
        public enable: boolean
    ){}
}
